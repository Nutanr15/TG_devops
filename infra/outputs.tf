output "cluster_name" {
  value = module.eks.cluster_name
}

output "ecr_repository_url" {
  value = aws_ecr_repository.repo.repository_url
}

output "raw_bucket_name" {
  value = aws_s3_bucket.raw.bucket
}

output "processed_bucket_name" {
  value = aws_s3_bucket.processed.bucket
}

output "irsa_role_arn" {
  value = aws_iam_role.irsa_role.arn
}

output "kubeconfig_command" {
  value = "aws eks update-kubeconfig --region ${var.aws_region} --name ${module.eks.cluster_name}"
}
