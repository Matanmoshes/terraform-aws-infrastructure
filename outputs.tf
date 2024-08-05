# Output the VPC ID
output "vpc_id" {
  value = aws_vpc.main.id
}

# Output the public subnet ID
output "public_subnet_id" {
  value = aws_subnet.public.id
}

# Output the private subnet ID
output "private_subnet_id" {
  value = aws_subnet.private.id
}

# Output the public IP of the web server instance
output "web_instance_public_ip" {
  value = aws_instance.web.public_ip
}

# Output the private IP of the backend server instance
output "backend_instance_private_ip" {
  value = aws_instance.backend.private_ip
}
