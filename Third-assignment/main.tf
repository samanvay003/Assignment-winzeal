provider "aws" {
  region = var.region
}

resource "aws_instance" "test-server" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  key_name      = var.key_name

  tags = {
    Name = "test-instance"
  }
}

output "instance_id" {
  value = aws_instance.test-server.id
}

output "public_ip_address" {
  value = aws_instance.test-server.public_ip
}
