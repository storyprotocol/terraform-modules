variable "global" {
  type = object({
    enabled             = bool
    region              = string
    environment         = string
    prefix              = string
    power_user_role_arn = string
  })
}

variable "params" {
  type = object({
    sa_policies = list(string)
    s3          = map(any)
    db = map(object({
      allocated_storage    = string
      storage_type         = string
      engine               = string
      engine_version       = string
      instance_class       = string
      db_name              = string
      username             = string
      port                 = string
      parameter_group_name = string
    }))
  })
}

variable "name" {
  type = string
}

variable "oidc_provider_url" {
  type = string
}

