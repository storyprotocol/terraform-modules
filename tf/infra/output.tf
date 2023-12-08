output "eks" {
  description = "EKS"
  value = {
    cluster_endpoint          = module.eks.cluster_endpoint
    cluster_security_group_id = module.eks.cluster_security_group_id
    cluster_name              = module.eks.cluster_name
    oidc_provider             = module.eks.oidc_provider
  }
}

output "vpc_sg_arns" {
  value = data.aws_security_groups.this.arns
}
