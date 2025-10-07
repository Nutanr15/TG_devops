module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = ">= 20.0.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.32"
  vpc_id          = var.vpc_id
  subnet_ids      = var.subnets

  eks_managed_node_groups = {
    default = {
      instance_types = ["t3.medium"]
      desired_size   = 2
      max_size       = 2
      min_size       = 1
    }
  }

  # ✅ Add these lines
  cluster_endpoint_public_access = true
  cluster_endpoint_private_access = false

  tags = {
    Environment = "dev"
    Project     = "TG-DevOps"
  }
}


