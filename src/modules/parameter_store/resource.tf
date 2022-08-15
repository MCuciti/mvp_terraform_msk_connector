resource "aws_ssm_parameter" "key" {
  name  = "/${var.environment}/${var.system_name}/${var.key}"
  type  = var.type
  value = var.value
}