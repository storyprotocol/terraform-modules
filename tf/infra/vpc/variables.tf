variable "cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "cluster_name" {
  description = "The name of the EKS cluster"
  type = string
}
