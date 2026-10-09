
#####################################################
# Security Groups and Rules
#####################################################

resource "aws_security_group" "alb_security_group" {
  name   = "alb_security_group"
  vpc_id = aws_vpc.portal_vpc.id

  tags = {
    Name = "ALB Security Group"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_tcp_inbound" {
  security_group_id = aws_security_group.alb_security_group.id
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "allow_alb_to_ec2" {
  security_group_id            = aws_security_group.alb_security_group.id
  referenced_security_group_id = aws_security_group.ec2_app_security_group.id

  ip_protocol = "tcp"
  from_port   = 80
  to_port     = 80

  description = "Allow ALB traffic to application targets"
}

resource "aws_security_group" "ec2_app_security_group" {
  name   = "app_security_group"
  vpc_id = aws_vpc.portal_vpc.id

  tags = {
    Name = "Application Security Group"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_app_to_ec2" {
  security_group_id = aws_security_group.ec2_app_security_group.id # The SG receiving the rule

  # Reference the source security group here:
  referenced_security_group_id = aws_security_group.alb_security_group.id

  ip_protocol = "tcp"
  from_port   = 80
  to_port     = 80
  description = "Allow TCP traffic from the ALB layer"
}

resource "aws_vpc_security_group_egress_rule" "allow_ec2_to_vpc_endpoints" {
  security_group_id            = aws_security_group.ec2_app_security_group.id
  referenced_security_group_id = aws_security_group.vpc_endpoint_sg.id

  ip_protocol = "tcp"
  from_port   = 443
  to_port     = 443
}

resource "aws_vpc_security_group_egress_rule" "allow_ec2_to_rds" {
  security_group_id            = aws_security_group.ec2_app_security_group.id
  referenced_security_group_id = aws_security_group.rds_security_group.id

  ip_protocol = "tcp"
  from_port   = 3306
  to_port     = 3306
}

resource "aws_security_group" "rds_security_group" {
  name   = "rds_security_group"
  vpc_id = aws_vpc.portal_vpc.id

  tags = {
    Name = "RDS Security Group"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ec2_to_rds" {
  security_group_id = aws_security_group.rds_security_group.id # The SG receiving the rule

  # Reference the source security group here:
  referenced_security_group_id = aws_security_group.ec2_app_security_group.id

  ip_protocol = "tcp"
  from_port   = 3306
  to_port     = 3306
  description = "Allow RDS traffic from the EC2 layer"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_rds_ipv4" {
  security_group_id = aws_security_group.rds_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_security_group" "vpc_endpoint_sg" {
  name        = "portal-vpc-endpoint-sg"
  description = "Allow HTTPS from portal application instances"
  vpc_id      = aws_vpc.portal_vpc.id
  tags = {
    Name = "portal-vpc-endpoint-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ec2_to_endpoint" {
  security_group_id = aws_security_group.vpc_endpoint_sg.id # The SG receiving the rule

  # Reference the source security group here:
  referenced_security_group_id = aws_security_group.ec2_app_security_group.id

  ip_protocol = "tcp"
  from_port   = 443
  to_port     = 443
  description = "Allow HTTPS traffic to the VPC endpoint"
}


resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_vpc_endpoint" {
  security_group_id = aws_security_group.vpc_endpoint_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_vpc_security_group_ingress_rule" "allow_https_to_alb" {
  security_group_id = aws_security_group.alb_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
  description       = "Allow HTTPS traffic to the ALB"
}