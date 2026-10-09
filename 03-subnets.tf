#####################################################
# Public Subnets
#####################################################

resource "aws_subnet" "public_subnet_a" {
  vpc_id            = aws_vpc.portal_vpc.id
  cidr_block        = "10.0.10.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Public Subnet A"
  }
}
resource "aws_subnet" "public_subnet_b" {
  vpc_id            = aws_vpc.portal_vpc.id
  cidr_block        = "10.0.20.0/24"
  availability_zone = "us-east-1c"

  tags = {
    Name = "Public Subnet B"
  }
}


#####################################################
# Private Application Subnets
#####################################################

resource "aws_subnet" "private_app_subnet_a" {
  vpc_id            = aws_vpc.portal_vpc.id
  cidr_block        = "10.0.30.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Private App Subnet A"
  }
}
resource "aws_subnet" "private_app_subnet_b" {
  vpc_id            = aws_vpc.portal_vpc.id
  cidr_block        = "10.0.40.0/24"
  availability_zone = "us-east-1c"

  tags = {
    Name = "Private App Subnet B"
  }
}

#####################################################
# Private Database Subnets
#####################################################

resource "aws_subnet" "private_db_subnet_a" {
  vpc_id            = aws_vpc.portal_vpc.id
  cidr_block        = "10.0.50.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Private DB Subnet A"
  }
}
resource "aws_subnet" "private_db_subnet_b" {
  vpc_id            = aws_vpc.portal_vpc.id
  cidr_block        = "10.0.60.0/24"
  availability_zone = "us-east-1c"

  tags = {
    Name = "Private DB Subnet B"
  }
}