# resource aws_iam_policy to do kms decrypt
resource "aws_iam_policy" "kms_decrypt_policy" {
  name        = "kms-decrypt-policy-${local.name}"
  description = "Allow decrypting KMS key for App: ${local.name}"
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "kms:Decrypt",
        ],
        Resource = aws_kms_key.this.arn,
      },
    ],
  })
}

resource "aws_iam_role" "this" {
  name = local.name

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Federated" : "arn:aws:iam::${local.aws_account_id}:oidc-provider/${var.oidc_provider_url}"
        },
        "Action" : "sts:AssumeRoleWithWebIdentity",
        "Condition" : {
          "StringEquals" : {
            "${var.oidc_provider_url}:sub" : "system:serviceaccount:${local.k8s_namespace}:${local.k8s_sa_name}",
            "${var.oidc_provider_url}:aud" : "sts.amazonaws.com"
          }
        }
      }
    ]
  })
}

data "aws_iam_policy" "this" {
  for_each = local.k8s_sa_policy_names
  arn      = "arn:aws:iam::aws:policy/${each.value}"
}

resource "aws_iam_role_policy_attachment" "this" {
  for_each   = local.k8s_sa_policy_names
  role       = aws_iam_role.this.name
  policy_arn = data.aws_iam_policy.this[each.value].arn
}

# Attach the KMS decrypt policy to the role
resource "aws_iam_role_policy_attachment" "kms_decrypt" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.kms_decrypt_policy.arn
}
