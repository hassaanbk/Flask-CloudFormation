output "rds" {
  value = aws_db_instance.this_rds
}

output "aws_security_group" {
  value = aws_security_group.this_db_sg
}

output "aws_db_parameter_group" {
  value = aws_db_parameter_group.this
}

output "aws_ssm_parameter" {
  value = aws_ssm_parameter.db_endpoint
}