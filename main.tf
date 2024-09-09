resource "aws_instance" "ec2" {
  ami           = "ami-0b72821e2f351e396"
  instance_type = "t3.micro"
#   vpc_id = var.ec2_vpc_id
  subnet_id = var.ec2_subnet_id
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  iam_instance_profile = aws_iam_instance_profile.test_profile.arn
  tags = {
    Name = "PublicAWS"
  }
}

resource "aws_security_group" "ec2_sg" {
  name   = "public-ec2-sg"
  vpc_id = var.ec2_vpc_id
  ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "TCP"
    cidr_blocks      = ["10.0.0.0/24"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_iam_role" "ec2_role" {
  name               = "public_ec2_role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_instance_profile" "test_profile" {
  name = "public_ec2_role"
  role = aws_iam_role.ec2_role.name
}

resource "aws_iam_role_policy_attachment" "test-attach1" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = data.aws_iam_policy.ssm_policy1.arn
}

resource "aws_iam_role_policy_attachment" "test-attach2" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = data.aws_iam_policy.ssm_policy2.arn
}