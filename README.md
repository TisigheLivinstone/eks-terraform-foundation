# EKS Terraform Foundation

Production-grade EKS cluster on AWS using reusable Terraform modules with separate state per environment.

Built in two parts that map directly to the blog post series:

- **Part 1 — Networking:** VPC, public/private subnets, NAT Gateways (1 per AZ), route tables
- **Part 2 — EKS:** Cluster, system + application node groups, IRSA, LB Controller, Cluster Autoscaler, Metrics Server

## Structure

```
eks-terraform-foundation/
├── bootstrap/                    # Run once — creates S3 + DynamoDB for remote state
├── modules/
│   ├── networking/               # Part 1 — VPC, subnets, NAT gateways, route tables
│   ├── eks/                      # Part 2 — EKS cluster, OIDC, IRSA, managed add-ons
│   ├── node-groups/              # Part 2 — System (tainted) + application node groups
│   └── addons/                   # Part 2 — LB Controller, Cluster Autoscaler, Metrics Server
└── environments/
    ├── dev/                      # 2 AZs, t3.medium, min 1 node
    └── production/               # 3 AZs, m5.large, 1-10 nodes
```

## Prerequisites

- Terraform >= 1.5
- AWS CLI v2 configured
- kubectl
- Helm 3

## Deployment

Step 1 — Bootstrap (run once):
cd bootstrap && terraform init && terraform apply

Step 2 — Deploy an environment:
cd environments/production
terraform init
terraform plan -out=prod.tfplan
terraform apply prod.tfplan

Step 3 — Configure kubectl:
aws eks update-kubeconfig --name production-livinstone-infra --region eu-west-1
kubectl get nodes
kubectl get pods -n kube-system

## Blog Posts

- Part 1: https://www.livinstone.dev/blog/terraform-multi-environment-iac
- Part 2: https://www.livinstone.dev/blog/building-production-eks-cluster-from-scratch
