terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "servers" {
  ami           = "ami-0b09ffb6d8b58ca91" #amazon linux
  instance_type = "t2.micro"

  for_each = toset(["dev", "qa", "prod"])

  tags = {
    Name = each.key
    Env  = each.key
  }
}

output "public_ips" {
  value = { for name, server in aws_instance.servers : name => server.public_ip }
}

output "private_ips" {
  value = { for name, server in aws_instance.servers : name => server.private_ip }
}


