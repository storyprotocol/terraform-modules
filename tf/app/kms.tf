resource "aws_kms_key" "this" {
  description             = "KMS for App: ${local.name}"
  deletion_window_in_days = 10
}

