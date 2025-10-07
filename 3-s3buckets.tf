provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "buckets" {
  count = 3

  bucket = "my-unique-bucket-${count.index + 1}"
}