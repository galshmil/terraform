#Creating Internet Gateway
resource "aws_internet_gateway" "gal_gw" {
  vpc_id = aws_vpc.gal_vpc.id

  tags = {
    Name = "gal_gw"
  }
}

#Creating Elastic IP For NAT Gateway
resource "aws_eip" "gal_nat_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.gal_gw]

  tags = {
    Name = "gal_nat_eip"
  }
}

#Creating NAT Gateway
resource "aws_nat_gateway" "gal_nat" {
  allocation_id = aws_eip.gal_nat_eip.id
  subnet_id     = aws_subnet.gal_public_subnet_01.id

  tags = {
    Name = "gal_nat"
  }
}
