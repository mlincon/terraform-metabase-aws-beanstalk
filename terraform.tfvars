/* 
This file is used to provide values to variables.
Alternatively, either use default values or provide the values during infrastructure provision

Terraform also automatically loads variable definitions files if:
- the files are named exactly terraform.tfvars or terraform.tfvars.json.
- the file name ends in .auto.tfvars or .auto.tfvars.json.

If the file name is say, variables.tfvars, specify that file in command line
terraform apply -var-file="variables.tfvars"
*/


# General
region  = "eu-central-1"
profile = "default"
default_tags = {
  Name : "metabase",
  project : "experiment"
}

# S3 Variables
s3_bucket_name           = "terraform-metabase-mxl-experiment"
s3_source_code_file_name = "metabase-aws-eb.zip"

# RDS variables
rds_instance_name     = "metabse-db"
rds_allocated_storage = 10
rds_db_engine         = "postgres"
rds_instance_class    = "db.t2.micro"
rds_db_name           = "devDB"
rds_username = "metaAdmin"
rds_password = "db-password-that-should-be-secured-properly"

# Beanstalk Application Variables
ebs_app_name        = "metabase-application"
ebs_app_description = "An instance of the Metabase BI tool"
# delete_source_from_s3     = true

ebs_app_version_name        = "metabase-application-version"
ebs_app_version_description = "The application version"

# Beanstalk Environment Variables
ebs_env_name          = "metabase-environment"
ebs_env_description   = "The environment for hosting the Metabse BI tool"
ebs_env_tier          = "WebServer"
ebs_app_version_label = "v0.36.5.1.metabase-aws-eb.zip"

# List of supported platforms/solution stacks:
# - https://docs.aws.amazon.com/elasticbeanstalk/latest/platforms/platforms-supported.html
# - https://docs.aws.amazon.com/elasticbeanstalk/latest/platforms/platforms-supported.html#platforms-supported.docker
ebs_env_platform = "64bit Amazon Linux 2 v3.1.2 running Docker"