provider "aws" {
  version = "~>3.0"
  region = "us-east-1"
}
resource "aws_vpc" "vpc11" {
  cidr_block = "192.168.0.0/16"
  tags = {
    Name = "myvpc"
  }
}
resource "aws_subnet" "sub1" {
  vpc_id = aws_vpc.vpc11.id
  cidr_block = "192.168.0.0/17"
  map_public_ip_on_launch = true
  tags = {
    Name = "sub1"
  }
}
resource "aws_internet_gateway" "myig" {
  vpc_id = aws_vpc.vpc11.id
  tags = {
    Name = "igw1"
  }
}
resource "aws_route_table" "myrt" {
  vpc_id = aws_vpc.vpc11.id
  tags = {
    Name = "rt1"
  }
}
resource "aws_route_table_association" "association1" {
  route_table_id = aws_route_table.myrt.id
  subnet_id = aws_subnet.sub1.id
}
resource "aws_route" "route1" {
  route_table_id = aws_route_table.myrt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.myig.id
}
resource "aws_security_group" "mysg1" {
  name = "ec2sg"
  vpc_id = aws_vpc.vpc11.id
  ingress {
    from_port = 22
    protocol  = "tcp"
    to_port   = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    protocol  = "-1"
    to_port   = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_instance" "myec2" {
  ami = "ami-0b0dcb5067f052a63"
  tags = {
    Name = "charec2"
  }
  instance_type = "t2.micro"
  key_name = aws_key_pair.key1.id
  subnet_id = aws_subnet.sub1.id
  security_groups = [aws_security_group.mysg1.id]
}
resource "aws_key_pair" "key1" {
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDrgb0fhZCtLdDgEeKjpAu2VoMmkume7mU4uogWrXi5ICzvPOOLsrECqf5l056RoAdg8oGaHd2kwoDo7DNkOPfRv2Yfiz8sqXilWPNlgB7hofyXJQ/ZnzI6SbHRF5RZrzDXwNWcITQom9LsYgV8CfpTpo4guccSnkvvy7gliEv+vodJlLclnqalyGD/nkrxLHnumIk85/qcN1tUqZABbK4FwsOuXmxsjlcKJEGWal/xFhVVsQ8yyLiPj563+BmAQfkfWhmH6B5pTs3cIUoDyK5MxQdHHh6N3LRfq/TclvBY8KDhYYD7VCfCZw+bBSzSOUgyB3oGqf3tOjQsxeJMkqrmB3NxfkAsUG+K9YPOz22RcfkMfw0esqXLXw4sfwhowERYK7TLLGY43c9cYg3OfXrrg9M3PypuElDah7wS85trtkWcUyVQljqyNR0fzNKbVfjbw9AdVT3J/+JyA8PIevpXDakFsNj31wYw16rb26Wtapu3aNUInFKDj4qpWD864uU= ajmal@DESKTOP-7KBHFQ2"
}
