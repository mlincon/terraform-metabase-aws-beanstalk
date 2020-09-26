variable "region" {
    type = string
    description = "AWS region"
}

variable "profile" {
    type = string
    description = "AWS profile"
}

variable "beanstalk_application_name" {
    type = string
    description = "Name of beanstalk application"
}

variable "env_platform" {
    type = string
    description = "The environment platform"
}