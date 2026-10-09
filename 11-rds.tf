resource "aws_db_instance" "portal_db" {
  allocated_storage           = 50
  db_name                     = "portal_db"
  engine                      = "mysql"
  engine_version              = "8.0.46"
  instance_class              = "db.t3.micro"
  storage_type                = "gp3"
  username                    = "stedman_admin"
  manage_master_user_password = true
  parameter_group_name        = "default.mysql8.0"
  publicly_accessible         = false
  # Lab deployments may use false to reduce cost.
  # Production design uses Multi-AZ.
  multi_az                = var.db_multi_az
  skip_final_snapshot     = true
  db_subnet_group_name    = aws_db_subnet_group.rds_subnet_group.name
  backup_retention_period = 1
  apply_immediately       = false
  vpc_security_group_ids = [
    aws_security_group.rds_security_group.id
  ]
  tags = {
    Name = "School Portal Database"
  }
}
