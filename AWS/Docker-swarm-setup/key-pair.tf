/*resource "aws_key_pair" "deployer" {
  key_name = "swarm"
  public_key = "C:/Projects/Terraform/Docker-swarm/swarm.pem"
}*/


resource "aws_key_pair" "deployer" {
  key_name   = "${var.key_name}"
  public_key = "${tls_private_key.example.public_key_openssh}"
}

variable "key_name" {default="swarm1"}
resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

