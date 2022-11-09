#Creating a VPC with CIDR and DNS names
resource "aws_vpc" "gal_vpc" {
  cidr_block           = "10.123.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "gal"
  }
}

#Creating Subnet On Specific VPC And AZ With Specific IP Range
resource "aws_subnet" "gal_public_subnet_01" {
  vpc_id                  = aws_vpc.gal_vpc.id
  cidr_block              = "10.123.0.0/18"
  map_public_ip_on_launch = true
  availability_zone       = "eu-west-1a"

  tags = {
    Name                        = "gal_public_01"
    "kubernetes.io/cluster/eks" = "shared"
    "kubernetes.io/role/elb"    = 1
  }
}

#Creating Subnet On Specific VPC And AZ With Specific IP Range
resource "aws_subnet" "gal_private_subnet_01" {
  vpc_id            = aws_vpc.gal_vpc.id
  cidr_block        = "10.123.64.0/18"
  availability_zone = "eu-west-1a"

  tags = {
    Name                              = "gal_private_01"
    "kubernetes.io/cluster/eks"       = "shared"
    "kubernetes.io/role/internal-elb" = 1
  }
}

#Creating Subnet On Specific VPC And AZ With Specific IP Range
resource "aws_subnet" "gal_private_subnet_02" {
  vpc_id            = aws_vpc.gal_vpc.id
  cidr_block        = "10.123.128.0/18"
  availability_zone = "eu-west-1b"

  tags = {
    Name                              = "gal_private_02"
    "kubernetes.io/cluster/eks"       = "shared"
    "kubernetes.io/role/internal-elb" = 1
  }
}
