# VPC
resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name        = "${var.environment}-${var.vpc_name}"
    environment = var.environment
  }
}

# Public Subnets
resource "aws_subnet" "public" {
  count = 3

  vpc_id            = aws_vpc.this.id
  cidr_block        = var.public_subnets[count.index]
  availability_zone = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.environment}-${var.vpc_name}-public-${count.index + 1}"
    environment = var.environment
    route_table = aws_route_table.public.id
  }
}

# Private Subnets
resource "aws_subnet" "private" {
  count = 3

  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name        = "${var.environment}-${var.vpc_name}-private-${count.index + 1}"
    environment = var.environment
  }
}

# Isolated Subnets
resource "aws_subnet" "isolated" {
  count = 3

  vpc_id            = aws_vpc.this.id
  cidr_block        = var.isolated_subnets[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name        = "${var.environment}-${var.vpc_name}-isolated-${count.index + 1}"
    environment = var.environment
  }
}

# Internet Gateway
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name        = "${var.environment}-${var.vpc_name}-igw"
    environment = var.environment
  }
}

# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name        = "${var.environment}-${var.vpc_name}-public-rt"
    environment = var.environment
  }
}

# Public Route Table Association
resource "aws_route_table_association" "public" {
  count = 3

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id

}