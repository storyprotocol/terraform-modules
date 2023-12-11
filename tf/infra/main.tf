module "vpc" {
  source       = "./vpc"
  cluster_name = local.cluster_name
}

