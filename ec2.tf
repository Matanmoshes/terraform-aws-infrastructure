# Create a web server instance in the public subnet
resource "aws_instance" "web" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.public.id
  key_name      = aws_key_pair.webserver-key.key_name

  vpc_security_group_ids = [aws_security_group.public_sg.id, aws_security_group.ssh_sg.id]

   user_data = <<-EOF
              #!/bin/bash
              sudo dnf update -y
              sudo dnf install -y nginx
              echo "<html><head><title>Welcome</title></head><body><h1>Welcome to my webserver</h1></body></html>" | sudo tee /usr/share/nginx/html/index.html
              sudo systemctl start nginx
              sudo systemctl enable nginx
              EOF

  tags = {
    Name      = "WebServer"
    terraform = "true"
  }
}

# Create a backend server instance in the private subnet
resource "aws_instance" "backend" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.private.id
  key_name      = aws_key_pair.webserver-key.key_name

  vpc_security_group_ids = [aws_security_group.private_sg.id, aws_security_group.ssh_sg.id]

  tags = {
    Name      = "BackendServer"
    terraform = "true"
  }
}
