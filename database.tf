# Create a database subnet group
resource "aws_db_subnet_group" "tec_db_sub_grp" {
  name       = "${var.project_name}-${var.environment}-database-subnets"
  description = "subnets for database instance"

  subnet_ids = [
    aws_subnet.tec_prv_data_sub_az1.id,
    aws_subnet.tec_prv_data_sub_az2.id
  ]

  tags = {
    Name = "${var.project_name}-${var.environment}-database-subnets"
  }
}

# Create the RDS instance
resource "aws_db_instance" "tec_dev_rds_db" {
  identifier              = "tec-dev-rds-db"
  engine                  = "mysql"
  engine_version          = "8.0.36"
  instance_class          = "db.t3.medium"
  skip_final_snapshot     = true
  allocated_storage       = 20
  max_allocated_storage   = 100
  db_subnet_group_name    = aws_db_subnet_group.database_tec_db_sub_grp.name
  vpc_security_group_ids  = [aws_security_group.database_tec_security_grp.id]
  multi_az                = true 
  username                = var.db_master_username
  password                = var.db_master_password
  db_name                 = "autorentappdb"
  storage_encrypted       = true
  backup_retention_period = 7
  parameter_group_name    = "mysql_para_group_name" 

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "tec-dev-rds-db"
  }
}