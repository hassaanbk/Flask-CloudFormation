
# Generates a secure private key and encodes it as PEM
resource "tls_private_key" "key_pair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
# Create the Key Pair
resource "aws_key_pair" "key_pair" {
  key_name   = "ontario-key-pair"
  public_key = tls_private_key.key_pair.public_key_openssh
}
# Save file
resource "local_file" "ssh_key" {
  filename = "${aws_key_pair.key_pair.key_name}.pem"
  content  = tls_private_key.key_pair.private_key_pem
}

# Security group for the EC2 instances
resource "aws_security_group" "ec2_sg" {
  name_prefix = "this-ec2-sg-"
  vpc_id      = var.vpc_id
  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_launch_template" "this_lt" {
  name_prefix            = "this-lt-"
  image_id               = var.app_ami_id
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.key_pair.key_name
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  user_data = filebase64("./ec2/user_data.sh")
  iam_instance_profile {
    arn = aws_iam_instance_profile.this.arn
  }

  lifecycle {
    create_before_destroy = true
  }
  tags = {
    Name = "skillsontario"
  }
}

# Define the IAM role
resource "aws_iam_role" "this" {
  name = "this-role"

  # Attach an administrative policy to the role
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  # Attach the AdministratorAccess policy to the role
  # This policy grants full administrative access to all AWS services
  # You can also attach more specific policies as needed
  managed_policy_arns = ["arn:aws:iam::aws:policy/AdministratorAccess"]
}

# Define the IAM instance profile
resource "aws_iam_instance_profile" "this" {
  name = "this-instance-profile"

  # Associate the IAM role with the instance profile
  role = aws_iam_role.this.name
}
