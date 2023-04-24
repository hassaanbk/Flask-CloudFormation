output "aws_security_group" {
  value = aws_security_group.ec2_sg
}

output "aws_launch_template" {
  value = aws_launch_template.this_lt
}
