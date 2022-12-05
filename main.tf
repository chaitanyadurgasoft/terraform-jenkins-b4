provider "aws" {
  region = "us-east-1"
}
resource "aws_vpc" "dev-vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name = "${var.vpc_name}"
  }
}
resource "aws_internet_gateway" "dev-igw" {
  vpc_id = aws_vpc.dev-vpc.id
  tags = {
    Name = "${var.vpc_name}-IGW"
  }
}
resource "aws_subnet" "PublicSubnet" {
  vpc_id            = aws_vpc.dev-vpc.id
  cidr_block        = var.PublicSubnet_cird
  availability_zone = var.az
  tags = {
    Name = "${var.vpc_name}-PublicSubnet"
  }
}
resource "aws_route_table" "PublicRoute" {
  vpc_id = aws_vpc.dev-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dev-igw.id
  }
  tags = {
    Name = "${var.vpc_name}-PublicRoute"
  }
}
resource "aws_route_table_association" "Public_subnet_add" {
  subnet_id      = aws_subnet.PublicSubnet.id
  route_table_id = aws_route_table.PublicRoute.id

}

resource "aws_security_group" "user_defined" {
  vpc_id      = aws_vpc.dev-vpc.id
  name        = "customiazed inbound"
  description = "allow customized inbound rules through dynamic blocking"
  dynamic "ingress" {
    for_each = local.ingress_rules1
    content {
      description = ingress.value.description
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]

    }
  }
  dynamic "ingress" {
    for_each = local.ingress_rules2
    content {
      description = ingress.value.description
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]

    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "Devops-Webserver" {
  ami                         = var.imagename
  key_name                    = "AWSB4-KEY"
  instance_type               = "t2.micro"
  availability_zone           = var.az
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.PublicSubnet.id
  vpc_security_group_ids      = ["${aws_security_group.user_defined.id}"]
  tags = {
    Name = "${var.vpc_name}-WebServer-1"
  }

}
