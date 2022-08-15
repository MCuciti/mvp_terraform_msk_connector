# data "aws_ssm_parameter" "vpc_id" {
#   name = "/dev/common/vpc/id"
# }

# data "aws_ssm_parameter" "private_subnets" {
#   name = "/dev/common/subnet/private/ids"
# }

# data "aws_ssm_parameter" "deployment_bucket_id" {
#   name = "/dev/common/deployment/s3/id"
# }

# # create NAT gateway to route network of private subnet
# resource "aws_eip" "nat_eip" {
#   vpc = true
# }

# resource "aws_nat_gateway" "temp_mvp_nat_gateway" {
#   allocation_id = aws_eip.nat_eip.id
#   subnet_id     = split(",", data.aws_ssm_parameter.private_subnets.value)[0]

#   tags = {
#     Name = "gw NAT"
#   }

#   # To ensure proper ordering, it is recommended to add an explicit dependency
#   # on the Internet Gateway for the VPC.
#   # depends_on = [aws_internet_gateway.example]
# }

# data "aws_route_table" "selected" {
#   subnet_id = split(",", data.aws_ssm_parameter.private_subnets.value)[0]
# }

# resource "aws_route_table" "private_subnet_egress" {
#   vpc_id = aws_vpc.example.id

#   route {
#     cidr_block = "10.0.1.0/24"
#     gateway_id = aws_internet_gateway.example.id
#   }

#   route {
#     ipv6_cidr_block        = "::/0"
#     egress_only_gateway_id = aws_egress_only_internet_gateway.example.id
#   }

#   tags = {
#     Name = "example"
#   }
# }
