terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region                   = "us-west-2"
  shared_config_files      = ["/home/joey/.tf/aws_conf"]
  shared_credentials_files = ["/home/joey/.tf/aws_cred"]
  profile                  = "default"
}

resource "aws_s3_bucket" "jafner-dev" {
  bucket = "jafner-dev"
  tags = {
    Name        = "Jafner.dev"
    Environment = "Prod"
  }
}

resource "aws_s3_bucket_ownership_controls" "jafner-dev" {
    bucket = aws_s3_bucket.jafner-dev.id
    rule {
        object_ownership = "BucketOwnerPreferred"
    }
}

resource "aws_s3_bucket_acl" "jafner-dev" {
    depends_on = [aws_s3_bucket_ownership_controls.jafner-dev]
    bucket = aws_s3_bucket.jafner-dev.id
    acl = "private"
}

resource "aws_s3_bucket_cors_configuration" "jafner-dev" {
    bucket = aws_s3_bucket.jafner-dev.id

    cors_rule {
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
  }
}

data "aws_iam_policy_document" "Custom_S3BucketFullControl_jafner-dev" {
    version = "2012-10-17"
    statement {
        effect = "Allow"
        actions = [
            "s3:*",
            "s3-object-lambda:*"
        ]
        resources = [
            "arn:aws:s3:::jafner-dev"
        ]
    }
}

data "aws_iam_policy_document" "Custom_S3ReadBucket_jafner-dev" {
    statement {
        effect = "Allow"
        actions = [
            "s3:Get*",
            "s3:List*",
            "s3:Describe*",
            "s3-object-lambda:Get*",
            "se-object-lambda:List*"
        ]
        resources = [
            "arn:aws:s3:::jafner-dev"
        ]
    }
}

resource "aws_budgets_budget" "dont-bankrupt-me" {
  name              = "budget"
  budget_type       = "COST"
  limit_amount      = "30.00"
  limit_unit        = "USD"
  time_unit         = "MONTHLY"
  time_period_start = "2024-08-01_00:01"
}