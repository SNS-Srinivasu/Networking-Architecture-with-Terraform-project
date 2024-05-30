provider "aws" {
    region = "ap-south-1"
}

// creating instance 

resource "aws_instance" "aws-practice" {
    ami = "ami-0f58b397bc5c1f2e8"
    key_name = "saipandu001"
    instance_type = "t2.micro"
    availability_zone = "ap-south-1b"
    subnet_id = aws_subnet.practice_subnet.id
    vpc_security_group_ids = [aws_security_group.practice-vpc-sg.id]
}
// creating VPC

resource "aws_vpc" "practice-vpc" {
    cidr_block = "10.1.0.0/16"
}

// creating subnet 

resource "aws_subnet" "practice_subnet" {
    vpc_id = aws_vpc.practice-vpc.id
    cidr_block = "10.1.0.0/16"

    tags = {
      Name = "practice_subnet"
    }
}

// creating internet Gateway

resource "aws_internet_gateway" "practice-igw" {
    vpc_id = aws_vpc.practice-vpc.id

    tags = {
      Name = "practice-igw"
    }
}

// creating route tables

resource "aws_route_table" "practice-rt" {
    vpc_id = aws_vpc.practice-vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.practice-igw.id
    }
        tags = {
            Name = "practice-rt"
        }
    
} 

// associate subnet with rout tables

resource "aws_route_table_association" "practice-rt-association"{
    subnet_id = aws_subnet.practice_subnet.id
    route_table_id = aws_route_table.practice-rt.id
  
}

// creating security group

resource "aws_security_group" "practice-vpc-sg" {
    name = "practice-vpc-sg"
    vpc_id = aws_vpc.practice-vpc.id

    ingress { 
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"] 

    }
    tags = {
      Name = "allow_tls"
    }
}

