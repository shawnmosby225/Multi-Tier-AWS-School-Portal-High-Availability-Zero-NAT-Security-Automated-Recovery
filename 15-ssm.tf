resource "aws_ssm_parameter" "db_endpoint" {
  name  = "/school-portal/database/endpoint"
  type  = "String"
  value = aws_db_instance.portal_db.address
}