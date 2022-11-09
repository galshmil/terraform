#Creating A Rout Table On Specific VPC With Route
resource "aws_route_table" "gal_public_rt" {
  vpc_id = aws_vpc.gal_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gal_gw.id
  }

  tags = {
    Name = "gal_public_rt"
  }
}

#Creating A Rout Table On Specific VPC With Route
resource "aws_route_table" "gal_private_rt" {
  vpc_id = aws_vpc.gal_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.gal_nat.id
  }

  tags = {
    Name = "gal_private_rt"
  }
}

#Associating Route Table To Subnet
resource "aws_route_table_association" "gal_rt_association_pub" {
  subnet_id      = aws_subnet.gal_public_subnet_01.id
  route_table_id = aws_route_table.gal_public_rt.id
}

#Associating Route Table To Subnet
resource "aws_route_table_association" "gal_rt_association_priv_01" {
  subnet_id      = aws_subnet.gal_private_subnet_01.id
  route_table_id = aws_route_table.gal_private_rt.id
}

#Associating Route Table To Subnet
resource "aws_route_table_association" "gal_rt_association_priv_02" {
  subnet_id      = aws_subnet.gal_private_subnet_02.id
  route_table_id = aws_route_table.gal_private_rt.id
}
