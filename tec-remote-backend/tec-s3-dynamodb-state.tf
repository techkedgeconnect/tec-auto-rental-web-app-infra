# Define terraform provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "eu-west-2"
}

# Create s3 bucket for storing remote backend
resource "aws_s3_bucket" "terraform_state" {
  bucket = "tec-auto-rent-state-bucket"
}

# Configure s3 bucket versioning
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Create a dynamodB table for state lock
resource "aws_dynamodb_table" "terraform_state_lock" {
  name           = "tec-auto-rent-state-tbl"
  hash_key       = "LockID"
  read_capacity  = 20
  write_capacity = 20

  attribute {
    name = "LockID"
    type = "S"
  }
}