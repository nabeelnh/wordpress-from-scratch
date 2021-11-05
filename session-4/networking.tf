# Internet Gateway
resource "aws_internet_gateway" "gateway" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags = local.common_tags
}



# ----------------------------------------------------------------------
# Public Routing
# ----------------------------------------------------------------------

# Public Routing table
resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.vpc.id}"
  tags = {
    Name        = "${var.env}-public-route-table"
    Environment = var.env
  }
}


# Create the Route inside the Public Route Table
resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gateway.id
}


# Associate Route Table to Public Subnets
resource "aws_route_table_association" "public-a" {
  subnet_id      = aws_subnet.web-subnet1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public-b" {
  subnet_id      = aws_subnet.web-subnet2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public-c" {
  subnet_id      = aws_subnet.web-subnet3.id
  route_table_id = aws_route_table.public.id
}




# ----------------------------------------------------------------------
# Required Private Resources
# ----------------------------------------------------------------------

# Elastic IP for NAT
resource "aws_eip" "nat_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.gateway]
}


# NAT
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.web-subnet1.id
  depends_on    = [aws_internet_gateway.gateway]
  tags = {
    Name        = "NAT"
    Environment = var.env
  }
}



# ----------------------------------------------------------------------
# Private Routing
# ----------------------------------------------------------------------

# Private Routing table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name        = "${var.env}-private-route-table"
    Environment = var.env
  }
}


# Create the Routes inside the Private Route Table
resource "aws_route" "private_nat_gateway" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}


# Associate Route Table to Private Subnets
resource "aws_route_table_association" "private-a" {
  subnet_id      = aws_subnet.db-subnet1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private-b" {
  subnet_id      = aws_subnet.db-subnet2.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private-c" {
  subnet_id      = aws_subnet.db-subnet3.id
  route_table_id = aws_route_table.private.id
}