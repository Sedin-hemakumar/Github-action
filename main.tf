provider "aws" {
  region = "ap-south-1"
}
resource "aws_instance" "example" {
ami = "ami-02b8269d5e85954ef"
instance_type = "t2.medium"
tags = {
  name = "Action"
}
}
