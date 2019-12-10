provider "aws" {
  shared_credentials_file = "/c/Users/u0180495/.aws/credentials"
  region     = "us-east-1"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

// NETWORK
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "main"
  }
}

data "aws_vpc" "default" {
  id = aws_vpc.main.id
}

resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "Main"
  }
}

resource "aws_internet_gateway" "k8-int-gateway" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "k8-route-table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.k8-int-gateway.id
  }
}

resource "aws_route_table_association" "k8-subnet-association" {
  route_table_id = aws_route_table.k8-route-table.id
  subnet_id = aws_subnet.main.id

  depends_on = [aws_route_table.k8-route-table]
}

// SECURITY GROUP
resource "aws_security_group" "k8-sg" {
  name        = "my-simple-k8-ec2-sg"
  description = "Eureka Service Security Group"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port       = 80
    protocol        = "tcp"
    to_port         = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 22
    protocol        = "tcp"
    to_port         = 22
    cidr_blocks = ["159.220.58.2/32"]
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_instance" "my-simple-k8-cluster" {
  ami             = data.aws_ami.ubuntu.id
  instance_type   = "t2.medium"


  subnet_id = aws_subnet.main.id
  security_groups = [aws_security_group.k8-sg.id]
  key_name = "TR-Personal"

  user_data = "${file("user-data.sh")}"

  tags = {
    Name = "k8-cluster"
  }
}

output "instance_dns" {
  value = aws_instance.my-simple-k8-cluster.public_dns
}