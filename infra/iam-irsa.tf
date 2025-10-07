# IAM Policy for S3 access
data "aws_iam_policy_document" "s3_access" {
  statement {
    sid = "ReadRawData"
    actions   = ["s3:GetObject", "s3:ListBucket"]
    resources = [
      "arn:aws:s3:::${var.raw_bucket_name}",
      "arn:aws:s3:::${var.raw_bucket_name}/*"
    ]
  }

  statement {
    sid = "WriteProcessedData"
    actions   = ["s3:PutObject"]
    resources = [
      "arn:aws:s3:::${var.processed_bucket_name}/*"
    ]
  }
}

resource "aws_iam_policy" "s3_access_policy" {
  name        = "${var.cluster_name}-s3-access-policy"
  description = "Allow read from raw-data and write to processed-data"
  policy      = data.aws_iam_policy_document.s3_access.json
}

# IRSA Role
data "aws_eks_cluster" "this" {
  name = module.eks.cluster_name
  depends_on = [module.eks]
}

data "aws_eks_cluster_auth" "this" {
  name = module.eks.cluster_name
}

data "aws_iam_openid_connect_provider" "oidc" {
  arn = module.eks.oidc_provider_arn
}

data "aws_caller_identity" "current" {}

resource "aws_iam_role" "irsa_role" {
  name = "${var.cluster_name}-irsa-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = module.eks.oidc_provider_arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "${replace(module.eks.cluster_oidc_issuer_url, "https://", "")}:sub" = "system:serviceaccount:${var.namespace}:${var.service_account_name}"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "irsa_policy_attach" {
  role       = aws_iam_role.irsa_role.name
  policy_arn = aws_iam_policy.s3_access_policy.arn
}
