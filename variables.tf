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

# iam

variable "ebs_iam_role_name" {
  type        = string
  description = "IAM role name"
}


# s3 vars

variable "s3_bucket_name" {
  type        = string
  description = "Name of S3 bucket hosting the code"
}

variable "s3_source_code_file_name" {
  type        = string
  description = <<EOT
    Name of zip file containing the source code.
    Download from: https://downloads.metabase.com/v0.36.5.1/metabase-aws-eb.zip
    EOT
}

# rds vars

variable "rds_instance_name" {
  type        = string
  description = "The name of the RDS instance, if omitted, Terraform will assign a random, unique identifier"
}

variable "rds_allocated_storage" {
  type        = number
  description = "The allocated storage in gibibytes"
  default     = 20
}

variable "rds_db_engine" {
  type        = string
  description = "The database engine to use"
}

variable "rds_instance_class" {
  type        = string
  description = "The instance type of the RDS instance"
}

variable "rds_db_name" {
  type = string
  # use "heredoc" to insert multi-line comment
  description = <<EOT
    The name of the database to create when the DB instance is created. 
    If this parameter is not specified, no database is created in the DB instance
    EOT
}

variable "rds_username" {
  type        = string
  description = "Username for the master DB user"
}

variable "rds_port" {
  type        = number
  description = "The port on which the DB accepts connections"
}

variable "rds_password" {
  type        = string
  description = <<EOT
    Password for the master DB user. 
    Note that this may show up in logs, and it will be stored in the state file.
    EOT
}

variable "rds_skip_final_snapshot" {
  type        = bool
  description = <<EOT
    Determines whether a final DB snapshot is created before the DB instance is deleted. 
    If true is specified, no DBSnapshot is created.
    EOT
  default     = true
}

variable "rds_publicly_accessible" {
  type        = bool
  description = "Bool to control if instance is publicly accessible"
  default     = false
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

variable "delete_source_from_s3" {
  type        = bool
  default     = true
  description = "Whether to delete a version's source bundle from S3 when the application version is deleted"
}

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

variable "ebs_env_platform" {
  type        = string
  description = "The environment platform"
}

variable "ebs_app_version_label" {
  type        = string
  description = "Unique name for this version of the application code"
}