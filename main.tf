resource "aws_instance" "foo" {
  ami           = "ami-0e35ddab05955cf57"
  instance_type = "t2.micro"
  key_name      = "karone"
  associate_public_ip_address = true

  vpc_security_group_ids = ["sg-052bd96f28b077ad9"]  # use your existing SG

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
}
