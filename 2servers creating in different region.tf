terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}


terraform {
  backend "s3" {
    bucket         = "newtf101"   # must exist beforehand
    key            = "dev/terraform.tfstate"         # path inside the bucket
    region         = "us-east-1"

  }
}



provider "aws" {
  region = "us-east-1"
  alias  = "us_east"
}

provider "aws" {
  region = "us-west-1"
  alias  = "us_west"
}

resource "aws_instance" "east_server" {
  provider      = aws.us_east
  ami           = "ami-0b09ffb6d8b58ca91" #amazonlinux
  instance_type = "t2.micro"

  tags = {
    Name = "server-east"
  }
}

resource "aws_instance" "west_server" {
  provider      = aws.us_west
  ami           = "ami-0d9e15a8edf01ec21" #amazonlinux
  instance_type = "t2.micro"
  
  life_cycle {
     prevent_destroy  = true

  }

  tags = {
    Name = "server-west"
  }
}
