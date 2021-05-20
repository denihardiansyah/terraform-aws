#Create 1 vpc with subnet public and private connecting NAT Gateway
resource "aws_vpc" "vpc_master" {
  provider             = aws.region-master
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "vpc_stockbit"
  }
}

#Create IGW
resource "aws_internet_gateway" "igw" {
  provider = aws.region-master
  vpc_id   = aws_vpc.vpc_master.id

  tags = {
    Name = "igw_vpc_stockbit"
  }
}

#Get all variable zone
data "aws_availability_zones" "abc" {
  provider = aws.region-master
  state    = "available"
}

#Create subnet internet public
resource "aws_subnet" "public_subnet_zone_a" {
  provider                = aws.region-master
  availability_zone       = element(data.aws_availability_zones.abc.names, 0)
  vpc_id                  = aws_vpc.vpc_master.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet_a"
  }
}

#Create subnet private
resource "aws_subnet" "private_subnet_zone_b" {
  provider          = aws.region-master
  availability_zone = element(data.aws_availability_zones.abc.names, 1)
  vpc_id            = aws_vpc.vpc_master.id
  cidr_block        = "10.0.2.0/24"

  tags = {
    Name = "private_subnet_b"
  }
}

#Create Route Table internet
resource "aws_route_table" "internet_route" {
  provider = aws.region-master
  vpc_id   = aws_vpc.vpc_master.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "route-internet"
  }
}

#Associate subnet to Internet
resource "aws_route_table_association" "public_subnet_a" {
  provider       = aws.region-master
  subnet_id      = aws_subnet.public_subnet_zone_a.id
  route_table_id = aws_route_table.internet_route.id
}

#Create aws_eip
resource "aws_eip" "ip_public" {
  provider = aws.region-master
  vpc      = true
}

#Create NAT Gateway
resource "aws_nat_gateway" "ngw" {
  provider      = aws.region-master
  allocation_id = aws_eip.ip_public.id
  subnet_id     = aws_subnet.public_subnet_zone_a.id

  tags = {
    Name = "nat_gw_for_subnet_private"
  }
}

#Create Route Table Private
resource "aws_route_table" "private_route" {
  provider = aws.region-master
  vpc_id   = aws_vpc.vpc_master.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw.id
  }

  tags = {
    Name = "private-route"
  }
}

#Associate Private subnet 
resource "aws_route_table_association" "private_subnet_b" {
  provider       = aws.region-master
  subnet_id      = aws_subnet.private_subnet_zone_b.id
  route_table_id = aws_route_table.private_route.id
}
