provider "aws" {
  region  = var.region
  profile = var.profile
}

# s3

resource "aws_s3_bucket" "metabase-bucket" {
  bucket = var.s3_bucket_name
  tags   = var.default_tags
}

resource "aws_s3_bucket_object" "metabase-bucket-object" {
  bucket = aws_s3_bucket.metabase-bucket.id
  key    = var.source_code_file_name
  source = "./code/${var.source_code_file_name}"
  tags   = var.default_tags
}

# application

resource "aws_elastic_beanstalk_application" "metabase-app" {
  name        = var.beanstalk_app_name
  description = var.beanstalk_app_description
  tags        = var.default_tags

  # appversion_lifecycle {
  #   service_role          = 
  #   delete_source_from_s3 = var.delete_source_from_s3
  # }
}

# application code/version
resource "aws_elastic_beanstalk_application_version" "metabase-application-version" {
  name        = var.beanstalk_app_version_name
  application = var.beanstalk_app_name
  description = var.beanstalk_app_version_description
  bucket      = aws_s3_bucket.metabase-bucket.id
  key         = aws_s3_bucket_object.metabase-bucket-object.id
}

# environment

resource "aws_elastic_beanstalk_environment" "metabase-env" {
  name                = var.beanstalk_env_name
  description         = var.beanstalk_env_description
  application         = var.beanstalk_app_name
  tier                = var.beanstalk_env_tier
  solution_stack_name = var.env_platform
  tags                = var.default_tags
  version_label       = var.beanstalk_app_version_name
}


# Sources:
# https://tech.ovoenergy.com/aws-elasticbeanstalk-terraform/
# https://blog.seamlesscloud.io/2020/07/aws-elastic-beanstalk-infrastructure-in-code-with-terraform/