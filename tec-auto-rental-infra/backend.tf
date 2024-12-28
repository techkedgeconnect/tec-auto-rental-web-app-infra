# Configure backend for storing terraform state files
terraform {
  backend "s3" {
    bucket         = "tec-auto-rent-state-bucket"
    key            = "tec-auto-rental-infra/terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "tec-auto-rent-state-tbl"
  }
}