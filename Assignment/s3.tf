provider "aws" {
 region = "us-east-1"

}



resource "aws_s3_bucket" "b" {
  bucket = "ca-bucket"


  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}
