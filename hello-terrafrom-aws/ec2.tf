
resource "aws_instance" "foo" {

  ami           = "ami-044cbf116270193a6" # ap-northeast-1
  instance_type = "t4g.nano"

  subnet_id = aws_subnet.my_subnet.id

  associate_public_ip_address = "true"

  key_name = "yosuke-ssh-key-20240729"

  vpc_security_group_ids = [
    aws_security_group.my_app_sg.id
  ]

  tags = {
    Name = "yoske"
  }
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.foo.public_ip
}

output "instance_ssh_command" {
  description = "SSH command to connect to ec2"
  value       = "ssh ec2-user@${aws_instance.foo.public_ip}"
}
