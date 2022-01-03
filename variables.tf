# key variable
variable "key_name" {
  default = "ec2Key"
}

# base_path variable
variable "base_path" {
  default = "/home/leooamaral/Documents/estudos/estagio/trilha-devops/5-terraform/pratica/terraform_project/"
}

# private key 
resource "tls_private_key" "private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# aws keypair
resource "aws_key_pair" "key_pair" {
  depends_on = [tls_private_key.private_key]
  key_name   = var.key_name
  public_key = tls_private_key.private_key.public_key_openssh
}

# save privateKey
resource "local_file" "saveKey" {
  depends_on = [aws_key_pair.key_pair]
  content = tls_private_key.private_key.private_key_pem
  filename = "${var.base_path}${var.key_name}.pem"
}
