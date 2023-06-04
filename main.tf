terraform {
  backend "s3" {}
  required_version = "~> 1.4.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.67.0"
    }
  }
}

provider "aws" {
  region = var.local.region
}

data "aws_caller_identity" "current" {}