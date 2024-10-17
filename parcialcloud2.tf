terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>3.0"
    }
  }
}

provider "aws" {}


resource "aws_vpc" "parcial_vpc" {
  cidr_block = "70.0.0.0/16"

  tags = {
    Name = "parcial_vpc"
  }
}

resource "aws_internet_gateway" "parcial_igw" {
  vpc_id = aws_vpc.parcial_vpc.id

  tags = {
    Name = "parcial_igw"
  }
}

resource "aws_route_table" "parcial_route_table_public" {
  vpc_id = aws_vpc.parcial_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.parcial_igw.id
  }

  tags = {
    Name = "parcial_route_table"
  }
}

resource "aws_route_table" "parcial_route_table_private" {
  vpc_id = aws_vpc.parcial_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.parcial_igw.id
  }

  tags = {
    Name = "parcial_route_table"
  }
}

resource "aws_subnet" "public_subnet_01" {
  vpc_id                  = aws_vpc.parcial_vpc.id
  cidr_block              = "70.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-west-2a"

  tags = {
    Name = "public_subnet_01"
  }
}

resource "aws_subnet" "public_subnet_02" {
  vpc_id                  = aws_vpc.parcial_vpc.id
  cidr_block              = "70.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-west-2b"

  tags = {
    Name = "public_subnet_02"
  }
}

resource "aws_route_table_association" "public_subnet_01_association" {
  subnet_id      = aws_subnet.public_subnet_01.id
  route_table_id = aws_route_table.parcial_route_table_public.id
}

resource "aws_route_table_association" "public_subnet_02_association" {
  subnet_id      = aws_subnet.public_subnet_02.id
  route_table_id = aws_route_table.parcial_route_table_public.id
}

resource "aws_subnet" "private_subnet_01" {
  vpc_id                  = aws_vpc.parcial_vpc.id
  cidr_block              = "70.0.3.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "us-west-2c"

  tags = {
    Name = "private_subnet_01"
  }
}

resource "aws_subnet" "private_subnet_02" {
  vpc_id                  = aws_vpc.parcial_vpc.id
  cidr_block              = "70.0.4.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "us-west-2d"

  tags = {
    Name = "private_subnet_02"
  }
}

resource "aws_route_table_association" "private_subnet_01_association" {
  subnet_id      = aws_subnet.private_subnet_01.id
  route_table_id = aws_route_table.parcial_route_table_private.id
}

resource "aws_route_table_association" "private_subnet_02_association" {
  subnet_id      = aws_subnet.private_subnet_02.id
  route_table_id = aws_route_table.parcial_route_table_private.id
}
