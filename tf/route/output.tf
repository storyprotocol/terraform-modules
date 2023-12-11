output "common_name" {
  value = var.params.common_name
}

output "certificate_arn" {
  value = aws_acm_certificate.this.arn
}

