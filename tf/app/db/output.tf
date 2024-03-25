output "name" {
  value = var.name
}

output "master_user_secret" {
  value = aws_db_instance.this.master_user_secret
}

output "endpoint" {
  value = aws_db_instance.this.endpoint
}

# Output private subnets ids
output "private_subnet_ids" {
  value = data.aws_subnets.private.ids
}
