variable "name" {
  type = string
}

variable "params" {
  type = object({
    allocated_storage    = string
    storage_type         = string
    engine               = string
    engine_version       = string
    instance_class       = string
    db_name              = string
    username             = string
    port                 = string
    parameter_group_name = string
  })
}

variable "aws_kms_key" {}

variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}
