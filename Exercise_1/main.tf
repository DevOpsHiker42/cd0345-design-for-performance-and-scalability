# Designate a cloud provider, region, and credentials

provider "aws" {
  # access_key and secret_key values stored as environment variables for security
  region = "us-east-1"
}

# Provision 4 AWS t2.micro EC2 instances named Udacity T2

resource "aws_instance" "Udacity_T2" {
  ami = "ami-0b5eea76982371e91"
  instance_type = "t2.micro"
  count = 4
  tags = {
    Name = "Udacity T2"
  }
}

# Provision 2 m4.large EC2 instances named Udacity M4

resource "aws_instance" "Udacity_M4" {
  ami = "ami-0b5eea76982371e91"
  instance_type = "m4.large"
  count = 2
  tags = {
    Name = "Udacity T2"
  }
}
