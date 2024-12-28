# allocate elastic ip. this eip will be used for the nat-gateway in the public subnet az1 
resource "aws_eip" "tec_eip1" {
  vpc = true

  tags = {
    Name        = "${var.project_name}-${var.environment}-eip1"
    Environment = var.environment
    Project     = var.project_name
    Owner       = "TechkedgeConnect DevOps Team"
    Purpose     = "Elastic IP for ${var.project_name} in ${var.environment}"
  }
}

# allocate elastic ip. this eip will be used for the nat-gateway in the public subnet az2
resource "aws_eip" "tec_eip2" {
  vpc = true

  tags = {
    Name        = "${var.project_name}-${var.environment}-eip2"
    Environment = var.environment
    Project     = var.project_name
    Owner       = "TechkedgeConnect DevOps Team"
    Purpose     = "Elastic IP for ${var.project_name} in ${var.environment}"
  }
}

# create nat gateway in public subnet az1
resource "aws_nat_gateway" "tec_nat_gw_az1" {
  allocation_id = aws_eip.tec_eip1.id
  subnet_id     = aws_subnet.tec_pub_sub_az1.id

  tags   = {
    Name = "${var.project_name}-${var.environment}-ng-az1"
  }

  # to ensure proper ordering, it is recommended to add an explicit dependency
  # on the internet gateway for the vpc
  # With depends_on, we ensure that the internet gateway is created before the natgateway
  depends_on = [aws_internet_gateway.tec-int_gw]
}

# create nat gateway in public subnet az2
resource "aws_nat_gateway" "tec_nat_gw_az2" {
  allocation_id = aws_eip.tec_eip2.id
  subnet_id     = aws_subnet.tec_pub_sub_az2.id

  tags   = {
    Name = "${var.project_name}-${var.environment}-ng-az2"
  }

  # to ensure proper ordering, it is recommended to add an explicit dependency
  # on the internet gateway for the vpc
  # With depends_on, we ensure that the internet gateway is created before the natgateway
  depends_on = [aws_internet_gateway.tec_int_gw]
}

# create private route table az1 and add route through nat gateway az1
resource "aws_route_table" "tec_prv_route_tbl_az1" {
  vpc_id            = aws_vpc.tec_vpc.id

  route {
    cidr_block      = "0.0.0.0/0"
    nat_gateway_id  = aws_nat_gateway.tec_nat_gateway_az1.id
  }

  tags   = {
    Name = "${var.project_name}-${var.environment}-private-rt-az1"
  }
}

# associate private app subnet az1 with private route table az1
resource "aws_route_table_association" "tec_prv_app_sub_az1_rt_az1_association" {
  subnet_id         = aws_subnet.tec_prv_app_sub_az1.id
  route_table_id    = aws_route_table.tec_prv_route_tbl_az1.id
}

# associate private data subnet az1 with private route table az1
resource "aws_route_table_association" "tec_prv_data_sub_az1_rt_az1_association" {
  subnet_id         = aws_subnet.tec_prv_data_sub_az1.id
  route_table_id    = aws_route_table.tec_prv_route_tbl_az1.id
}

# create private route table az2 and add route through nat gateway az2
resource "aws_route_table" "tec_prv_route_tbl_az2" {
  vpc_id            = aws_vpc.tec_vpc.id

  route {
    cidr_block      = "0.0.0.0/0"
    nat_gateway_id  = aws_nat_gateway.tec_nat_gw_az2.id
  }

  tags   = {
    Name = "${var.project_name}-${var.environment}-private-rt-az2"
  }
}

# associate private app subnet az2 with private route table az2
resource "aws_route_table_association" "tec_prv_app_sub_az2_rt_az2_association" {
  subnet_id         = aws_subnet.tec_prv_app_sub_az2.id
  route_table_id    = aws_route_table.tec_prv_route_tbl_az2.id
}

# associate private data subnet az2 with private route table az2
resource "aws_route_table_association" "tec_prv_data_sub_az2_rt_az2_association" {
  subnet_id         = aws_subnet.tec_prv_data_sub_az2.id
  route_table_id    = aws_route_table.tec_prv_route_tbl_az2.id
}