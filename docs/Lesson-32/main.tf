terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-north-1"
}

# Data source
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# Security Group
resource "aws_security_group" "web" {
  name        = "terraform-lab-web"
  description = "Security group for web server"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform-lab-web-sg"
  }
}

# EC2 Instance
resource "aws_instance" "web" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.web.id]

  user_data = <<-EOF
        #!/bin/bash
        yum update -y
        yum install -y httpd
        systemctl start httpd
        systemctl enable httpd
        echo "<h1>Hello from Terraform!</h1>" > /var/www/html/index.html
        echo "<p>Instance ID: $(curl -s http://169.254.169.254/latest/meta-data/instance-id)
        </p>" >> /var/www/html/index.html
        EOF

  tags = {
    Name = "terraform-lab-web-server"
  }
}

# Budget
resource "aws_budgets_budget" "m10bl" {
  name              = "monthly_budget"
  budget_type       = "COST"
  limit_amount      = "10"
  limit_unit = "USD"
  time_unit         = "MONTHLY"
  time_period_start = "2026-09-04_00:01"
}