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
    eks_addons = set(string)

    eks_managed_node_group_default_ami_type = string

    eks_managed_node_groups = map(object({
      name           = string
      instance_types = list(string)
      min_size       = number
      max_size       = number
      desired_size   = number
    }))
  })
}

