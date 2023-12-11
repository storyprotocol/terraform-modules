variable "global" {
  type = object({
    registration_email_address = string
    dns_challenge_provider     = string
  })
}

variable "params" {
  type = object({
    common_name = string
    subject_alternative_names = list(string)
  })
}

