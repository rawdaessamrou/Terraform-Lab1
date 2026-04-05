# 1- Create VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = { Name = "lab01-vpc" }
}

# 2- Create Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "main-igw" }
}

# 3 & 4- Create Route Tables
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "public-route-table" }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "private-route-table" }
}

# 5- Create Public Route (Sends 0.0.0.0/0 to IGW)
resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# 6- Subnets and Attachment
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  tags                    = { Name = "public-subnet" }
}

resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
  tags       = { Name = "private-subnet" }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# Explicitly associate private subnet to private RT
resource "aws_route_table_association" "private_assoc" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_rt.id
}