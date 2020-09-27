# general vars

variable "region" {
  type        = string
  description = "AWS region"
}

variable "profile" {
  type        = string
  description = "AWS profile"
}

variable "default_tags" {
  type        = map
  description = "Tags as key-value pairs"
}

# S3 vars
variable "s3_bucket_name" {
  type        = string
  description = "Name of S3 bucket hosting the code"
}

variable "source_code_file_name" {
  type        = string
  description = <<EOT
    Name of zip file containing the source code.
    Download from: https://downloads.metabase.com/v0.36.5.1/metabase-aws-eb.zip
    EOT
}


# app vars

variable "ebs_app_name" {
  type        = string
  description = "Name of beanstalk application"
}

variable "ebs_app_description" {
  type        = string
  description = "Short description of beanstalk application"
}

# variable "delete_source_from_s3" {
#   type        = bool
#   default     = true
#   description = "Whether to delete a version's source bundle from S3 when the application version is deleted"
# }

variable "ebs_app_version_name" {
  type        = string
  description = "Name of the application version"
}

variable "ebs_app_version_description" {
  type        = string
  description = "Short description of application version"
}

# env vars

variable "ebs_env_name" {
  type        = string
  description = "Name of beanstalk environment"
}

variable "ebs_env_description" {
  type        = string
  description = "Short description of beanstalk environment"
}

variable "ebs_env_tier" {
  type        = string
  default     = "WebServer"
  description = <<EOT
    AWS Elastic Beanstalk has two types of environment tiers to support different types of web applications. 
    - Web servers are standard applications that listen for and then process HTTP requests, typically over port 80. 
    - Workers are specialized applications that have a background processing task that listens for messages on an Amazon SQS queue. 
      Worker applications post those messages to your application by using HTTP
    EOT
}

variable "env_platform" {
  type        = string
  description = "The environment platform"
}

variable "ebs_app_version_label" {
  type        = string
  description = "Unique name for this version of the application code"
}