locals {
  msk_name = "temp-mvp-msk-sqs-connector"
  msk_config = {
    kafka_version               = "2.6.2"
    number_of_broker_nodes      = 3
    instance_type               = "kafka.t3.small"
    ebs_volume_size             = 10
    client_broker_encryption    = "TLS"
    enabled_allow_all_msk_users = true
  }

  #msk_tags = merge({}, var.default_tags)
}

resource "aws_security_group" "msk" {
  vpc_id = data.aws_ssm_parameter.vpc_id.value
}

# open everything for egress, but nothing for ingress
resource "aws_security_group_rule" "egress_allow_all" {
  type              = "egress"
  to_port           = 0
  protocol          = "-1"
  from_port         = 0
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.msk.id
}

resource "aws_kms_key" "msk" {
  description = "encryption at rest for MSK"
}

resource "aws_cloudwatch_log_group" "msk" {
  name = local.msk_name
}

###
# This configuration will need to be anabled by 2 step process:
# 1. Deploy with the flag turned true (allows anyone to hit the cluster as super admin)
# 2. Turn off this flag at environment overrides level (trigger the ACL to be in effective)
# 3. Turn this flag back on at environment overrides so that everyone now has authorization access to the cluster, but follows ACL permissions
###
resource "aws_msk_configuration" "msk" {
  kafka_versions = [lookup(local.msk_config, "kafka_version")]
  name           = local.msk_name

  server_properties = <<PROPERTIES
allow.everyone.if.no.acl.found = ${lookup(local.msk_config, "enabled_allow_all_msk_users")}
PROPERTIES
}

resource "aws_msk_scram_secret_association" "scram-secret" {
  cluster_arn     = aws_msk_cluster.msk.arn
  secret_arn_list = ["arn:aws:secretsmanager:us-west-2:284581930156:secret:AmazonMSK_Dev_Temp_Cluster-hNZZZi"]
}

resource "aws_msk_cluster" "msk" {
  cluster_name           = local.msk_name
  kafka_version          = lookup(local.msk_config, "kafka_version")
  number_of_broker_nodes = lookup(local.msk_config, "number_of_broker_nodes")

  configuration_info {
    arn      = aws_msk_configuration.msk.arn
    revision = aws_msk_configuration.msk.latest_revision
  }

  broker_node_group_info {
    instance_type   = lookup(local.msk_config, "instance_type")
    ebs_volume_size = lookup(local.msk_config, "ebs_volume_size")
    client_subnets  = split(",", data.aws_ssm_parameter.private_subnets.value)
    security_groups = ["sg-098c21cb073fd5440"]
  }

  client_authentication {
    sasl {
      scram = true
      iam   = true
    }
  }

  encryption_info {
    encryption_in_transit {
      client_broker = lookup(local.msk_config, "client_broker_encryption")
    }
    encryption_at_rest_kms_key_arn = aws_kms_key.msk.arn
  }

  logging_info {
    broker_logs {
      cloudwatch_logs {
        enabled   = true
        log_group = aws_cloudwatch_log_group.msk.name
      }
    }
  }

  #tags = local.msk_tags
}
