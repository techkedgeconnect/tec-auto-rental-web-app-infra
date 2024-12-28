# environment variables
variable "project_name" {
  description = "The name of the project"
  type        = string
}

variable "environment" {
  description = "The environment (e.g., dev, staging, prod)"
  type        = string
}

variable "region" {
  description = "The AWS region to deploy resources"
  type        = string
}

# vpc variables
variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "public_subnet_az1_cidr" {
  description = "The CIDR block for the first public subnet"
  type        = string
}

variable "public_subnet_az2_cidr" {
  description = "The CIDR block for the second public subnet"
  type        = string
}

variable "private_app_subnet_az1_cidr" {
  description = "The CIDR block for the first private app subnet"
  type        = string
}

variable "private_app_subnet_az2_cidr" {
  description = "The CIDR block for the second private app subnet"
  type        = string
}

variable "private_data_subnet_az1_cidr" {
  description = "The CIDR block for the first private data subnet"
  type        = string
}

variable "private_data_subnet_az2_cidr" {
  description = "The CIDR block for the second private data subnet"
  type        = string
}

# Security groups variable
variable "ssh_location" {
  description = "The IP address allowed for SSH access (in CIDR notation)"
  type        = string
}

# RDS variables
variable "db_master_username" {
  description = "The master username for the RDS database"
  type        = string
}

variable "db_master_password" {
  description = "The master password for the RDS database"
  type        = string
  sensitive   = true
}

# ACM variables
variable "domain_name" {
  description = "The domain name for the ACM certificate"
  type        = string
}

variable "alternative_names" {
  description = "The alternative domain names for the ACM certificate"
  type        = string
}

# S3 variables
variable "env_file_bucket_name" {
  description = "The name of the S3 bucket for storing environment files"
  type        = string
}

variable "env_file_name" {
  description = "The name of the environment file stored in the S3 bucket"
  type        = string
}

# ECS variables
variable "architecture" {
  description = "The architecture for ECS tasks (X86_64 or ARM64)"
  type        = string
}

variable "container_image" {
  description = "The URI of the container image in ECR"
  type        = string
}

# Route53 variables
variable "record_name" {
  description = "The DNS record name for Route53"
  type        = string
}