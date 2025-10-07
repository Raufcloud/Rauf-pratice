terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 5.0"
        }
    }


    backend "s3" {
        bucket      = "new-tf-1309"   #bucket name
        key         = "dev/terraform.tfstate"  #inside the bucket
        region      = "us-east-2"

    }
}


provider "aws" {
    region      = "us-east-1"
    alias       = "us-east"
}

provider "aws" {
    region      = "us-west-1"
    alias       = "us-west"
}

resource "aws_instance" "east_server" {
    provider            = aws.us-east
    ami                 = var.ami_id_east #amazonlinux
    instance_type       = "t2.micro"

    tags   = {
        Name = "server-east"
    }

    lifecycle {
        ignore_chnages = [tags]
    }
}

resource "aws_instance" "west_server" {
    provider            = aws.us-west
    ami                 = var.ami_id_west #amazonlinux
    instance_type       = "t2.micro"

    tags   = {
        Name = "server-west"
    }
        depends_on = [aws_instance.east_server]

    lifecycle {
        ignore_chnages = [tags]
    }
}

variable "ami_id_east" {
  type        = string
  default     = "ami-0b09ffb6d8b58ca91"
  description = "AMI ID for ec2 in us-east-1"
}

variable "ami_id_west" {
  type        = string
  default     = "ami-0d9e15a8edf01ec21"
  description = "AMI ID for ec2 in us-west-1"
}


output "east_server_ips" {
    value = { 
        public_ip = aws_instance.east_server.public_ip
        private_ip = aws_instance.east_server.private_ip
    }
}

output "west_server_ips" {
    value = { 
        public_ip = aws_instance.west_server.public_ip
        private_ip = aws_instance.west_server.private_ip
    }
}