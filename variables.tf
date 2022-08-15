# separate config of resouces in block for easy management
variable "vpc_config" {
  default = {}
}

variable "assume_role_name" {}

variable "domain_config" {
  default = {
    gl_domain = ""
    subdomain = ""
  }
}
