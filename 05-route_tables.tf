#####################################################
# Public Route Table, Assocations, and Routes
#####################################################

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.portal_vpc.id

  tags = {
    Name = "Public Route Table"
  }
}

resource "aws_route" "public_internet_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.portal_internet_gateway.id
}

resource "aws_route_table_association" "public_subnet_a_association" {
  subnet_id      = aws_subnet.public_subnet_a.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_subnet_b_association" {
  subnet_id      = aws_subnet.public_subnet_b.id
  route_table_id = aws_route_table.public_route_table.id
}

#####################################################
# Private Application Route Tables, Assocations, and Routes
#####################################################

resource "aws_route_table" "private_app_route_table_a" {
  vpc_id = aws_vpc.portal_vpc.id

  tags = {
    Name = "Application Route Table A"
  }
}

resource "aws_route_table" "private_app_route_table_b" {
  vpc_id = aws_vpc.portal_vpc.id

  tags = {
    Name = "Application Route Table B"
  }
}


resource "aws_route_table_association" "private_subnet_a_association" {
  subnet_id      = aws_subnet.private_app_subnet_a.id
  route_table_id = aws_route_table.private_app_route_table_a.id
}

resource "aws_route_table_association" "private_subnet_b_association" {
  subnet_id      = aws_subnet.private_app_subnet_b.id
  route_table_id = aws_route_table.private_app_route_table_b.id
}

#####################################################
# Private DB Route Tables, Assocations, and Routes
#####################################################

resource "aws_route_table" "private_db_route_table_a" {
  vpc_id = aws_vpc.portal_vpc.id

  tags = {
    Name = "DB Route Table A"
  }
}

resource "aws_route_table" "private_db_route_table_b" {
  vpc_id = aws_vpc.portal_vpc.id

  tags = {
    Name = "DB Route Table B"
  }
}

resource "aws_route_table_association" "private_db_a_association" {
  subnet_id      = aws_subnet.private_db_subnet_a.id
  route_table_id = aws_route_table.private_db_route_table_a.id
}

resource "aws_route_table_association" "private_db_b_association" {
  subnet_id      = aws_subnet.private_db_subnet_b.id
  route_table_id = aws_route_table.private_db_route_table_b.id
}