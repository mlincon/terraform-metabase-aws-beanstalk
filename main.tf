provider "aws" {
  region  = var.region
  profile = var.profile
}

resource "aws_elastic_beanstalk_application" "metabase-app" {
  name        = var.beanstalk_application_name
  description = "An instance of the Metabase BI tool"
  tags = {
    Name = "metabase-instance"
  }

}

resource "aws_elastic_beanstalk_environment" "metabase-env" {
  name        = "metabase-env"
  application = aws_elastic_beanstalk_application.metabase-app.name
  solution_stack_name = var.env_platform
}


# Sources:
# https://tech.ovoenergy.com/aws-elasticbeanstalk-terraform/