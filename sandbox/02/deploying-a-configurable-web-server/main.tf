terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.99.1"
    }
  }
}

variable "server_port" {
  description = "The port server will listen on"
  type        = number
  default = 8080
}

output "public_ip" {
  description = "The public IP address of the web server"
  value       = aws_instance.example.public_ip
}

provider "aws" {
  region  = "us-east-2"
  profile = "default"
}

resource "aws_instance" "example" {
  ami           = "ami-0fb653ca2d3203ac1"
  instance_type = "t3.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]

  user_data = <<-EOF
      #!/bin/bash
      echo "Hello, world" > index.html
      nohup busybox httpd -f -p ${var.server_port} &
      EOF

  user_data_replace_on_change = true

  tags = {
    Name = "terraform-example"
  }
}

resource "aws_security_group" "instance" {
  name = "terraform-example-instance"

  ingress {
    from_port = var.server_port
    to_port = var.server_port
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}