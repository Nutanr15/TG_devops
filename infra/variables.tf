variable "aws_region" {
  default = "us-east-1"
}

variable "vpc_id" {
  default = "vpc-0a13297bfc9d33f98"
}

variable "subnets" {
  type    = list(string)
  default = ["subnet-0ed9d1d699b7c7eea", "subnet-052f53570119888c6"]
}

variable "cluster_name" {
  default = "devops-eks-cluster"
}

variable "ecr_repo_name" {
  default = "data-transformer-repo"
}

variable "raw_bucket_name" {
  default = "raw-data-dev-nutan"
}

variable "processed_bucket_name" {
  default = "processed-data-dev-nutan"
}

variable "namespace" {
  default = "default"
}

variable "service_account_name" {
  default = "s3-access-sa"
}
