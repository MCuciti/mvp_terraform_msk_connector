resource "aws_mskconnect_connector" "sqs_source" {
  depends_on = [
    aws_msk_cluster.msk
  ]
  name = "sqs-source"

  kafkaconnect_version = "2.7.1"

  capacity {
    autoscaling {
      mcu_count        = 1
      min_worker_count = 1
      max_worker_count = 2

      scale_in_policy {
        cpu_utilization_percentage = 20
      }

      scale_out_policy {
        cpu_utilization_percentage = 80
      }
    }
  }

  connector_configuration = {
    "connector.class" = "com.nordstrom.kafka.connect.sqs.SqsSourceConnector"
    "tasks.max"       = "1"
    "topics"          = "TestTopicOne"
    "sqs.queue.url"   = aws_sqs_queue.sqs_source.url
    "sqs.region"      = "us-west-2"
  }

  kafka_cluster {
    apache_kafka_cluster {
      bootstrap_servers = aws_msk_cluster.msk.bootstrap_brokers_sasl_iam

      vpc {
        security_groups = ["sg-098c21cb073fd5440"]
        subnets         = split(",", data.aws_ssm_parameter.private_subnets.value)
      }
    }
  }

  kafka_cluster_client_authentication {
    authentication_type = "IAM"
  }

  kafka_cluster_encryption_in_transit {
    encryption_type = "TLS"
  }

  plugin {
    custom_plugin {
      arn      = aws_mskconnect_custom_plugin.msk-sqs-connector.arn
      revision = aws_mskconnect_custom_plugin.msk-sqs-connector.latest_revision
    }
  }

  service_execution_role_arn = "arn:aws:iam::284581930156:role/temp-mvp-kafka-sqs-connect-role"
}

resource "aws_mskconnect_connector" "sqs_sink" {
  depends_on = [
    aws_msk_cluster.msk
  ]
  name = "sqs-sink"

  kafkaconnect_version = "2.7.1"

  capacity {
    autoscaling {
      mcu_count        = 1
      min_worker_count = 1
      max_worker_count = 2

      scale_in_policy {
        cpu_utilization_percentage = 20
      }

      scale_out_policy {
        cpu_utilization_percentage = 80
      }
    }
  }

  connector_configuration = {
    "connector.class" = "com.nordstrom.kafka.connect.sqs.SqsSinkConnector"
    "tasks.max"       = "1"
    "topics"          = "TestTopicOne"
    "sqs.queue.url"   = aws_sqs_queue.sqs_sink.url
    "sqs.region"      = "us-west-2"
  }

  kafka_cluster {
    apache_kafka_cluster {
      bootstrap_servers = aws_msk_cluster.msk.bootstrap_brokers_sasl_iam

      vpc {
        security_groups = ["sg-098c21cb073fd5440"]
        subnets         = split(",", data.aws_ssm_parameter.private_subnets.value)
      }
    }
  }

  kafka_cluster_client_authentication {
    authentication_type = "IAM"
  }

  kafka_cluster_encryption_in_transit {
    encryption_type = "TLS"
  }

  plugin {
    custom_plugin {
      arn      = aws_mskconnect_custom_plugin.msk-sqs-connector.arn
      revision = aws_mskconnect_custom_plugin.msk-sqs-connector.latest_revision
    }
  }


  log_delivery {
    worker_log_delivery {
      cloudwatch_logs = {
        enabled   = true
        log_group = aws_cloudwatch_log_group.msk.name
      }
    }
  }
  service_execution_role_arn = "arn:aws:iam::284581930156:role/temp-mvp-kafka-sqs-connect-role"
}
