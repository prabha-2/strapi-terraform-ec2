terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

# Get correct Ubuntu AMI for ap-south-1
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]
  
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_security_group" "strapi_sg" {
  name_prefix = "strapi-final-"
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 1337
    to_port     = 1337
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

resource "aws_instance" "strapi" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.small"
  
  vpc_security_group_ids = [aws_security_group.strapi_sg.id]
  associate_public_ip_address = true

  user_data = <<-EOF
#!/bin/bash
apt-get update -y
apt-get install -y nodejs npm nginx

cd /home/ubuntu
npx create-strapi-app@latest myapp --quickstart --no-run
cd myapp
npm install
npm run build
npm run develop &
EOF

  tags = {
    Name = "Strapi-Final-ap-south1"
  }
}

output "public_ip" {
  value = aws_instance.strapi.public_ip
}

output "strapi_url" {
  value = "http://${aws_instance.strapi.public_ip}:1337"
}
