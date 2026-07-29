module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "${var.environment}-${var.project_name}"
  cluster_version = var.cluster_version

  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnet_ids

  # Public access lets kubectl work from your laptop.
  # Private access keeps kubelet-to-control-plane traffic inside the VPC.
  cluster_endpoint_public_access       = true
  cluster_endpoint_private_access      = true
  cluster_endpoint_public_access_cidrs = var.allowed_cidrs

  # IRSA: pods assume IAM roles via service account
  # instead of inheriting the node instance profile
  enable_irsa = true

  # Managed add-ons — AWS handles upgrades
  cluster_addons = {
    coredns            = { most_recent = true }
    kube-proxy         = { most_recent = true }
    vpc-cni            = { most_recent = true }
    aws-ebs-csi-driver = { most_recent = true }
  }

  cluster_enabled_log_types = ["api", "audit", "authenticator"]

  tags = var.tags
}
