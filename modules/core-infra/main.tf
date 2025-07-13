provider "aws" {
  region = var.region
}

data "aws_availability_zones" "available" {}

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = { Name = "medusa-vpc" }
}

resource "aws_subnet" "public" {
  count                   = 2
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  tags = { Name = "medusa-public-subnet-${count.index}" }
}

resource "aws_db_subnet_group" "medusa" {
  name       = "medusa-subnet-group"
  subnet_ids = aws_subnet.public[*].id
}

resource "aws_security_group" "db_sg" {
  name        = "medusa-db-sg"
  description = "Allow PostgreSQL"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "postgres" {
  identifier              = "medusa-db"
  engine                  = "postgres"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  name                    = var.db_name
  username                = var.db_username
  password                = var.db_password
  skip_final_snapshot     = true
  publicly_accessible     = true
  db_subnet_group_name    = aws_db_subnet_group.medusa.name
  vpc_security_group_ids  = [aws_security_group.db_sg.id]
  tags = { Name = "medusa-db" }
}