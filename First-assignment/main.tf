provider "aws" {
  region = "ap-south-1" 
}

resource "aws_vpc" "custom_vpc" {
  cidr_block = "10.0.0.0/16" 

resource "aws_subnet" "custom_subnet" {
  vpc_id            = aws_vpc.custom_vpc.id
  cidr_block        = "10.0.1.0/24" 
  availability_zone = "us-east-1a" 
}

resource "aws_internet_gateway" "custom_igw" {
  vpc_id = aws_vpc.custom_vpc.id
}

resource "aws_vpc_attachment" "custom_vpc_attachment" {
  vpc_id       = aws_vpc.custom_vpc.id
  internet_gateway_id = aws_internet_gateway.custom_igw.id
}

resource "aws_route_table" "custom_route_table" {
  vpc_id = aws_vpc.custom_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.custom_igw.id
  }
}

resource "aws_route_table_association" "custom_association" {
  subnet_id      = aws_subnet.custom_subnet.id
  route_table_id = aws_route_table.custom_route_table.id
}


resource "aws_security_group" "custom_sg" {
  name        = "custom_sg"
  description = "Allow SSH inbound traffic"

  vpc_id = aws_vpc.custom_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "my_key_pair" {
  key_name   = "my_key_pair"
  public_key = file("~/.ssh/id_rsa.pub") 
}

resource "aws_instance" "my_instance" {
  ami             = "ami-0c55b159cbfafe1f0" 
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.custom_subnet.id
  security_groups = [aws_security_group.custom_sg.name]
  key_name        = aws_key_pair.my_key_pair.key_name

  tags = {
    Name = "MyInstance"
  }
}
