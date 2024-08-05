# Configure the AWS provider
provider "aws" {
  region = "us-east-1"
}

# Create an SSH key pair resource using the existing public key
resource "aws_key_pair" "webserver-key" {
  key_name   = "webserver-key"
  public_key = file("~/.ssh/id_rsa.pub")
}
