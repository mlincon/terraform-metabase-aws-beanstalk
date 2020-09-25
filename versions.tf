terraform {
  required_version = ">=0.13.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws" # shorthand of: registry.terraform.io/hashicorp/aws
      version = "~> 3.0"
    }
  }
}