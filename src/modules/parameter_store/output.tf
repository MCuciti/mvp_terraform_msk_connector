output "name" {
  value = aws_ssm_parameter.key.name
}

output "value" {
  value = aws_ssm_parameter.key.value
}

output "arn" {
  value = aws_ssm_parameter.key.arn
}