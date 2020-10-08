provider "aws" {
  region  = var.region
  profile = var.profile
}


# IAM role

# policy document: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document
data "aws_iam_policy_document" "ebs-trusted-entity" {
  version = "2012-10-17"
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["elasticbeanstalk.amazonaws.com"]
    }
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role
resource "aws_iam_role" "ebs-service-role" {
  name               = var.ebs_iam_role_name
  assume_role_policy = data.aws_iam_policy_document.ebs-trusted-entity.json
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment
resource "aws_iam_role_policy_attachment" "ebs-role-policy-attach" {
  role       = aws_iam_role.ebs-service-role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkService"
}


# S3 bucket
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
resource "aws_s3_bucket" "metabase-bucket" {
  bucket = var.s3_bucket_name
  tags   = var.default_tags
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_object
resource "aws_s3_bucket_object" "metabase-bucket-object" {
  bucket = aws_s3_bucket.metabase-bucket.id
  key    = var.s3_source_code_file_name
  source = "./src/${var.s3_source_code_file_name}"
  tags   = var.default_tags

  depends_on = [aws_s3_bucket.metabase-bucket]
}

# RDS: Postgres
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance
resource "aws_db_instance" "metabase-postgres-db" {
  identifier        = var.rds_instance_name
  allocated_storage = var.rds_allocated_storage
  engine            = var.rds_db_engine
  # engine_version = # use the latest version
  instance_class      = var.rds_instance_class
  name                = var.rds_db_name
  username            = var.rds_username
  password            = var.rds_password
  port                = var.rds_port
  skip_final_snapshot = var.rds_skip_final_snapshot
  publicly_accessible = var.rds_publicly_accessible

  tags = var.default_tags
}

# Elastic Beanstalk Application
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elastic_beanstalk_application
resource "aws_elastic_beanstalk_application" "metabase-app" {
  name        = var.ebs_app_name
  description = var.ebs_app_description
  tags        = var.default_tags

  depends_on = [aws_db_instance.metabase-postgres-db]

  appversion_lifecycle {
    service_role          = aws_iam_role.ebs-service-role.arn
    delete_source_from_s3 = var.delete_source_from_s3
  }
}

# application code
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elastic_beanstalk_application_version
resource "aws_elastic_beanstalk_application_version" "metabase-app-version" {
  name        = var.ebs_app_version_name
  application = var.ebs_app_name
  description = var.ebs_app_version_description
  bucket      = aws_s3_bucket.metabase-bucket.id
  key         = aws_s3_bucket_object.metabase-bucket-object.id

  depends_on = [aws_elastic_beanstalk_application.metabase-app]
}

# Elastic Beanstalk Environment
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elastic_beanstalk_environment
resource "aws_elastic_beanstalk_environment" "metabase-env" {
  name                = var.ebs_env_name
  description         = var.ebs_env_description
  application         = var.ebs_app_name
  tier                = var.ebs_env_tier
  solution_stack_name = var.ebs_env_platform
  tags                = var.default_tags
  version_label       = aws_elastic_beanstalk_application_version.metabase-app-version.name

  # https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/command-options-general.html

  # Environment must have instance profile associated with it
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = "aws-elasticbeanstalk-ec2-role"
  }

  # RDS  
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "MB_DB_TYPE"
    value     = aws_db_instance.metabase-postgres-db.engine
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "MB_DB_DBNAME"
    value     = aws_db_instance.metabase-postgres-db.name
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "MB_DB_PORT"
    value     = aws_db_instance.metabase-postgres-db.port
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "MB_DB_USER"
    value     = aws_db_instance.metabase-postgres-db.username
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "MB_DB_PASS"
    value     = aws_db_instance.metabase-postgres-db.password
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "MB_DB_HOST"
    value     = aws_db_instance.metabase-postgres-db.endpoint
  }
}


# Sources:
# https://tech.ovoenergy.com/aws-elasticbeanstalk-terraform/
# https://blog.seamlesscloud.io/2020/07/aws-elastic-beanstalk-infrastructure-in-code-with-terraform/
# https://briozing.com/continuously-deploying-your-springboot-application-on-aws-using-elasticbeanstalk-rds-and-terraform/
# https://candland.net/elixir/2018/09/20/beanstalk_with_terraform.html
# https://dev.to/rolfstreefkerk/how-to-setup-a-basic-vpc-with-ec2-and-rds-using-terraform-3jij#rds
# https://github.com/wardviaene/terraform-demo