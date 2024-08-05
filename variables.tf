# Define the variables used in the configuration
variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  default = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  default = "10.0.2.0/24"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "key_name" {
  description = "SSH key pair name"
  default     = "webserver-key"  # key name defined in aws_key_pair resource
}

variable "ami_id" {
  description = "AMI ID for the instances"
  default     = "ami-0ba9883b710b05ac6"  # Amazon Linux 2023 AMI (64-bit x86)
}

variable "home_ip" {
  description = "Home IP address for SSH access"
  default     = "62.56.134.54/32"
}
