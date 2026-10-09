#####################################################
# Internet Gateway
#####################################################

resource "aws_internet_gateway" "portal_internet_gateway" {
  vpc_id = aws_vpc.portal_vpc.id

  tags = {
    Name = "Public Gateway"
  }
}