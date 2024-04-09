variable "eks" {
  type = any
}

variable "addons" {
  type    = set(string)
  default = []
}

variable "region" {
  type = string
  default = ""
}

variable "role_alb" {
  type = string
  default = ""
}
