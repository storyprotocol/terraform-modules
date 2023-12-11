resource "tls_private_key" "this" {
  algorithm = "RSA"
}

resource "acme_registration" "this" {
  account_key_pem = tls_private_key.this.private_key_pem
  email_address   = var.global.registration_email_address
}

resource "acme_certificate" "this" {
  account_key_pem           = acme_registration.this.account_key_pem
  common_name               = var.params.common_name
  subject_alternative_names = try(var.params.subject_alternative_names, [])

  dns_challenge {
    provider = var.global.dns_challenge_provider
  }
}

resource "aws_acm_certificate" "this" {
  private_key       = acme_certificate.this.private_key_pem
  certificate_body  = acme_certificate.this.certificate_pem
  certificate_chain = join("", [acme_certificate.this.certificate_pem, acme_certificate.this.issuer_pem])
}
