resource "aws_security_group" "rds_sg" {
  name        = "rds_sg"
  description = "rds security group"
  vpc_id      = var.vpc_id

  ingress {
    from_port = 3306
    to_port   = 3306
    protocol  = "tcp"

    cidr_blocks = var.cidr_blocks
  }

  egress {
    from_port = 0
    to_port   = 65535
    protocol  = "tcp"

    cidr_blocks = var.cidr_blocks
  }

  tags = {
    Name = "RDS Sg"
  }
}

resource "aws_security_group" "ec_sg" {
  name        = "ec_sg"
  description = "Elasticache security group"
  vpc_id      = var.vpc_id

  ingress {
    from_port = 6379
    to_port   = 6379
    protocol  = "tcp"

    cidr_blocks = var.cidr_blocks
  }

  egress {
    from_port = 0
    to_port   = 65535
    protocol  = "tcp"

    cidr_blocks = var.cidr_blocks
  }

  tags = {
    Name = "EC Sg"
  }
}

resource "aws_security_group" "lambda_sg" {
  name        = "lambda_sg"
  description = "Lambda security group"
  vpc_id      = var.vpc_id

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = var.cidr_blocks
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = var.cidr_blocks
  }

  tags = {
    Name = "lambda Sg"
  }
}


resource "aws_security_group" "alb_sg" {
  name        = "alb_sg"
  description = "ALB security group"
  vpc_id      = var.vpc_id

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = var.cidr_blocks
  }

  tags = {
    Name = "alb Sg"
  }
}


resource "aws_security_group" "ec2_sg" {
  name        = "ec2_sg"
  description = "ec2 security group"
  vpc_id      = var.vpc_id

  ingress {
    from_port = 6080
    to_port   = 6080
    protocol  = "tcp"

    cidr_blocks = var.pub_cidr_blocks
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = var.cidr_blocks
  }

  tags = {
    Name = "ec2 Sg"
  }
}
