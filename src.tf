module "src" {
  source = "./src"

  environment        = local.environment
  region             = local.region
  aws_account_number = local.aws_account_number

  domain_config = var.domain_config
}
