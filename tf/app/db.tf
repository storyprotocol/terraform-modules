
module "db" {
  source   = "./db"
  for_each = local.db

  name        = each.key == "_" ? local.name : "${local.name}-${each.key}"
  params      = each.value
  aws_kms_key = aws_kms_key.this

  cluster_name = local.cluster_name
}
