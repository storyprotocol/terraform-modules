resource "aws_secretsmanager_secret" "this" {
  name       = local.name_uniq
  kms_key_id = aws_kms_key.this.arn
}

