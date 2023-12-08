output "iam_role" {
  value = aws_iam_role.this.arn
}

output "db_instance_master_user_secret_arn" {
  description = "The ARN of the master user secret"
  value       = try(module.db.instance.master_user_secret[0].secret_arn, null)
}

output "db_instance_endpoint" {
  description = "The connection endpoint"
  value       = try(module.db.instance.endpoint, null)
}

output "bucket_domain_names" {
  description = "Bucket domain names"
  value       = try([for x in aws_s3_bucket.this : x.bucket_domain_name], null)
}

