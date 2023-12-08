resource "aws_s3_bucket" "this" {
  for_each = local.s3
  bucket   = each.key == "_" ? local.name : "${local.name}-${each.key}"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  for_each = local.s3
  bucket   = aws_s3_bucket.this[each.key].id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.this.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

