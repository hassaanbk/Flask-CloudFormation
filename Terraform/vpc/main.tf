
# Create a new VPC
resource "aws_vpc" "this_vpc" {
  cidr_block = var.vpc_cidr
}

# Create private subnets using a loop
resource "aws_subnet" "private_subnets" {
  count = length(var.private_subnet_cidr_blocks)

  vpc_id            = aws_vpc.this_vpc.id
  cidr_block        = var.private_subnet_cidr_blocks[count.index]
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name = "private-subnet-${count.index + 1}"
  }
}

# Create public subnets using a loop
resource "aws_subnet" "public_subnets" {
  count = length(var.public_subnet_cidr_blocks)

  vpc_id                  = aws_vpc.this_vpc.id
  cidr_block              = var.public_subnet_cidr_blocks[count.index]
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-${count.index + 1}"
  }
}

# Create an internet gateway and attach it to the VPC
resource "aws_internet_gateway" "this_igw" {
  vpc_id = aws_vpc.this_vpc.id
}

# Create route tables for private and public subnets
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.this_vpc.id
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.this_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this_igw.id
  }
}

# Associate private and public subnets with their corresponding route tables using a loop
resource "aws_route_table_association" "private_associations" {
  count = length(aws_subnet.private_subnets)

  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "public_associations" {
  count = length(aws_subnet.public_subnets)

  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}

# Create a NAT gateway in one of the public subnets
resource "aws_eip" "this_eip" {
  vpc = true
}

resource "aws_nat_gateway" "this_nat_gateway" {
  allocation_id = aws_eip.this_eip.id
  subnet_id     = aws_subnet.public_subnets[0].id
}



