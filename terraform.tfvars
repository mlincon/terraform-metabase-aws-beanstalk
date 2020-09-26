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
region = "eu-central-1"
profile = "default"

# Beanstalk Application Variables
beanstalk_application_name = "metabase-application"


# Beanstalk Environment Variables



# List of supported platforms/solution stacks:
# - https://docs.aws.amazon.com/elasticbeanstalk/latest/platforms/platforms-supported.html
# - https://docs.aws.amazon.com/elasticbeanstalk/latest/platforms/platforms-supported.html#platforms-supported.docker
env_platform = "64bit Amazon Linux 2 v3.1.2 running Docker"