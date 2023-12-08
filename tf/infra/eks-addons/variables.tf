variable "eks" {
  type = any
}

variable "addons" {
  type    = set(string)
  default = []
}

