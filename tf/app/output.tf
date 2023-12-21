output "iam_role" {
  value = aws_iam_role.this.arn
}

output "db" {
  value = module.db
}

output "bucket_domain_names" {
  description = "Bucket domain names"
  value       = try([for x in aws_s3_bucket.this : x.bucket_domain_name], null)
}

