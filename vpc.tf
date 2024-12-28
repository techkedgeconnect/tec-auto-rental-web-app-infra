# Create a VPC
resource "aws_vpc" "tec_vpc" {
  cidr_block = var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_name}-${var.environment}-vpc"
  }
}

# Create internet gateway and attach it to vpc
resource "aws_internet_gateway" "tec_int_gw" {
  vpc_id = aws_vpc.tec_vpc.id

  tags = {
    Name = "${var.project_name}-${var.environment}-igw"
    }
}

# use data source to get all availability zones in region we are using
data "aws_availability_zones" "availability_zones" {}

# create public subnet az1
resource "aws_subnet" "tec_pub_sub_az1" {
  vpc_id = aws_vpc.tec_vpc.id
  cidr_block = var.public_subnet_az1_cidr
  availability_zone = data.aws_availability_zones.availability_zones.names [0]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-${var.environment}-public-az1"
  }
}

# create public subnet az2
resource "aws_subnet" "tec_pub_sub_az2" {
  vpc_id = aws_vpc.tec_vpc.id
  cidr_block = var.public_subnet_az2_cidr
  availability_zone = data.aws_availability_zones.availability_zones.names [1]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-${var.environment}-public-az2"
  }
}

# create route table and add public route
resource "aws_route_table" "tec_pub_route_tbl" {
  vpc_id = aws_vpc.tec_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tec_int_gw.id
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-public-rt"
  }
}

# associate public subnet az1 to "public route table"
resource "aws_route_table_association" "tec_pub_sub_az1_rt_association" {
  subnet_id = aws_subnet.tec_pub_sub_az1.id
  route_table_id = aws_route_table.tec_pub_route_tbl.id
}

# associate public subnet az2 to "public route table"
resource "aws_route_table_association" "tec_pub_sub_az2_rt_association" {
  subnet_id = aws_subnet.tec_pub_sub_az2.id
  route_table_id = aws_route_table.tec_pub_route_tbl.id
}

# create private app subnet az1
resource "aws_subnet" "tec_prv_app_sub_az1" {
  vpc_id = aws_vpc.tec_vpc
  cidr_block = var.private_app_subnet_az1_cidr
  availability_zone = data.aws_availability_zones.availability_zones.names [0]
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.project_name}-${var.environment}-private-app-az1"
  }
}

# create private app subnet az2
resource "aws_subnet" "tec_prv_app_sub_az2" {
  vpc_id = aws_vpc.tec_vpc.id
  cidr_block = var.private_app_subnet_az2_cidr
  availability_zone = data.aws_availability_zones.availability_zones.names [1]
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.project_name}-${var.environment}-private-app-az2"
  }
}

# Create private data subnet az1
resource "aws_subnet" "tec_prv_data_sub_az1" {
  vpc_id = aws_vpc.tec_vpc.id
  cidr_block = var.private_data_subnet_az1_cidr
  availability_zone = data.aws_availability_zones.availability_zones.names [0]
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.project_name}-${var.environment}-private-data-az1"
  }
}

# Create private data subnet az2
resource "aws_subnet" "tec_prv_data_sub_az2" {
  vpc_id = aws_vpc.tec_vpc.id
  cidr_block = var.private_data_subnet_az2_cidr
  availability_zone = data.aws_availability_zones.availability_zones.names [1]
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.project_name}-${var.environment}-private-data-az2"
  }
}