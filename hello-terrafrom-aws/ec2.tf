
resource "aws_instance" "foo" {

  ami           = "ami-044cbf116270193a6" # ap-northeast-1
  instance_type = "t4g.nano"

  subnet_id = aws_subnet.my_subnet.id

  associate_public_ip_address = "true"

  key_name = "yosuke-ssh-key-20240729"

  vpc_security_group_ids = [
    aws_security_group.my_app_sg.id
  ]

  iam_instance_profile = aws_iam_instance_profile.ec2_access_profile.id

  tags = {
    Name = "yoske"
  }
}

resource "aws_iam_role_policy" "ec2_policy" {
  name = "ec2_policy"
  role = aws_iam_role.ec2_role.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:List*",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role" "ec2_role" {
  name = "ec2_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_instance_profile" "ec2_access_profile" {
  name = "ec2_access_profile"
  role = aws_iam_role.ec2_role.name
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.foo.public_ip
}

output "instance_ssh_command" {
  description = "SSH command to connect to ec2"
  value       = "ssh -i \"~/Downloads/yosuke-ssh-key-20240729.pem\" ec2-user@${aws_instance.foo.public_ip}"
}
