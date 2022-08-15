resource "aws_sqs_queue" "sqs_source" {
  name                  = "temp_mvp_msk_sqs_source.fifo"
  fifo_queue            = true
  deduplication_scope   = "messageGroup"
  fifo_throughput_limit = "perMessageGroupId"
}

resource "aws_sqs_queue" "sqs_sink" {
  name                  = "temp_mvp_msk_sqs_sink.fifo"
  fifo_queue            = true
  deduplication_scope   = "messageGroup"
  fifo_throughput_limit = "perMessageGroupId"
}
