module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.0.0"

  cluster_name    = "terraform-eks-cluster"
  cluster_version = "1.30"

  cluster_endpoint_public_access = true
  cluster_endpoint_private_access = false

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  eks_managed_node_groups = {
    ng1 = {
      desired_size   = 2
      max_size       = 3
      min_size       = 1
      instance_types = ["t3.small"]
      subnet_ids     = module.vpc.private_subnets
    }

    ng2 = {
      desired_size   = 1
      max_size       = 2
      min_size       = 1
      instance_types = ["t3.small"]
      subnet_ids     = module.vpc.private_subnets
    }
  }
}