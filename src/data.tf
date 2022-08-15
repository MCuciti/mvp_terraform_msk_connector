data "aws_ssm_parameter" "vpc_id" {
  name = "/dev/common/vpc/id"
}

data "aws_ssm_parameter" "private_subnets" {
  name = "/dev/common/subnet/private/ids"
}

data "aws_ssm_parameter" "deployment_bucket_id" {
  name = "/dev/common/deployment/s3/id"
}
