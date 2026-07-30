terraform {
  required_version = ">= 1.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
  }

  backend "s3" {
    bucket         = "YOUR_PROJECT_NAME-tfstate-YOUR_ACCOUNT_ID"  # update after running bootstrap
    key            = "production/terraform.tfstate"
    region         = "eu-west-1"
    encrypt        = true
    dynamodb_table = "livinstone-infra-tfstate-lock"
  }
}

provider "aws" {
  region = var.region
  default_tags {
    tags = local.tags
  }
}

# Helm uses your local kubeconfig (~/.kube/config)
# Run: aws eks update-kubeconfig --name production-livinstone-infra --region eu-west-1
# before running terraform apply for the addons
provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

locals {
  tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

# Part 1 — Networking foundation
module "networking" {
  source = "../../modules/networking"

  project_name         = var.project_name
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  availability_zones   = var.availability_zones
  private_subnet_cidrs = var.private_subnet_cidrs
  public_subnet_cidrs  = var.public_subnet_cidrs
  tags                 = local.tags
}

# Part 2 — EKS cluster (uses VPC outputs from Part 1)
module "eks" {
  source = "../../modules/eks"

  project_name       = var.project_name
  environment        = var.environment
  cluster_version    = var.cluster_version
  vpc_id             = module.networking.vpc_id
  private_subnet_ids = module.networking.private_subnet_ids
  allowed_cidrs      = var.allowed_cidrs
  tags               = local.tags
}

# Part 2 — Node groups
module "node_groups" {
  source = "../../modules/node-groups"

  project_name              = var.project_name
  environment               = var.environment
  cluster_name              = module.eks.cluster_name
  private_subnet_ids        = module.networking.private_subnet_ids
  application_instance_types = var.application_instance_types
  application_min_size      = var.application_min_size
  application_max_size      = var.application_max_size
  application_desired_size  = var.application_desired_size
  tags                      = local.tags
}

# IRSA roles for add-ons
data "aws_caller_identity" "current" {}

module "lb_controller_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.0"

  role_name                              = "${var.environment}-${var.project_name}-lb-controller"
  attach_load_balancer_controller_policy = true
  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
    }
  }
}

module "cluster_autoscaler_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.0"

  role_name                        = "${var.environment}-${var.project_name}-cluster-autoscaler"
  attach_cluster_autoscaler_policy = true
  cluster_autoscaler_cluster_names = [module.eks.cluster_name]
  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:cluster-autoscaler-aws-cluster-autoscaler"]
    }
  }
}

# Part 2 — Add-ons (LB Controller, Cluster Autoscaler, Metrics Server)
module "addons" {
  source                      = "../../modules/addons"
  cluster_name                = module.eks.cluster_name
  region                      = var.region
  vpc_id                      = module.networking.vpc_id
  lb_controller_role_arn      = module.lb_controller_irsa.iam_role_arn
  cluster_autoscaler_role_arn = module.cluster_autoscaler_irsa.iam_role_arn
  depends_on                  = [module.node_groups]
}
