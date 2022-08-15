provider "aws" {
  region = local.region
  default_tags {
    tags = {
      environment = "temp-dev"
      project     = "mvp-kafka-sqs-connector"
      source      = "NA"
      temp        = "True"
    }
  }
}

provider "aws" {
  alias  = "infrastructure"
  region = local.region
}
