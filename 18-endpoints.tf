resource "aws_vpc_endpoint" "secretsmanager" {
  vpc_id            = aws_vpc.portal_vpc.id
  service_name      = "com.amazonaws.us-east-1.secretsmanager"
  vpc_endpoint_type = "Interface"

  subnet_ids = [
    aws_subnet.private_app_subnet_a.id,
    aws_subnet.private_app_subnet_b.id
  ]

  security_group_ids = [
    aws_security_group.vpc_endpoint_sg.id
  ]
  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = ["secretsmanager:GetSecretValue"]
        Resource  = aws_db_instance.portal_db.master_user_secret[0].secret_arn
      }
    ]
  })
  private_dns_enabled = true

  tags = {
    Name = "portal-secretsmanager-endpoint"
  }
}

resource "aws_vpc_endpoint" "ssm" {
  vpc_id            = aws_vpc.portal_vpc.id
  service_name      = "com.amazonaws.us-east-1.ssm"
  vpc_endpoint_type = "Interface"

  subnet_ids = [
    aws_subnet.private_app_subnet_a.id,
    aws_subnet.private_app_subnet_b.id
  ]

  security_group_ids = [
    aws_security_group.vpc_endpoint_sg.id
  ]

  private_dns_enabled = true

  tags = {
    Name = "portal-ssm-endpoint"
  }
}

resource "aws_vpc_endpoint" "ssmmessages" {
  vpc_id            = aws_vpc.portal_vpc.id
  service_name      = "com.amazonaws.us-east-1.ssmmessages"
  vpc_endpoint_type = "Interface"

  subnet_ids = [
    aws_subnet.private_app_subnet_a.id,
    aws_subnet.private_app_subnet_b.id
  ]

  security_group_ids = [
    aws_security_group.vpc_endpoint_sg.id
  ]

  private_dns_enabled = true

  tags = {
    Name = "portal-ssmmessages-endpoint"
  }
}