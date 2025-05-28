provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "foo" {
  ami           = "ami-0e35ddab05955cf57"  # Amazon Linux 2 AMI
  instance_type = "t2.micro"
  key_name      = "karone"  # Optional: If you want to SSH in

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>Hello from Terraform Web Server!</h1>" > /var/www/html/index.html
              EOF

  tags = {
    Name = "myproject_server"
  }

  # Optional: Add a security group allowing HTTP
  vpc_security_group_ids = [aws_security_group.allow_http.id]
}

resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow HTTP inbound traffic"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

