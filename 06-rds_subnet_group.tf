#####################################################
# Private DB RDS Subnet Group
#####################################################

resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "school-portal-rds-subnet-group"
  subnet_ids = [aws_subnet.private_db_subnet_a.id, aws_subnet.private_db_subnet_b.id]

  tags = {
    Name = "RDS DB subnet group"
  }
}