data "aws_s3_bucket" "msk_sqs_plugin" {
  bucket = "gl-temp-mvp-connector"
}

resource "aws_mskconnect_custom_plugin" "msk-sqs-connector" {
  name         = "msk-sqs-connector"
  content_type = "JAR"
  location {
    s3 {
      bucket_arn = data.aws_s3_bucket.msk_sqs_plugin.arn
      file_key   = "kafka-connect-sqs-1.4.0.jar"
    }
  }
}
