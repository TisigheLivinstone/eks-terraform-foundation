output "vpc_id"           { value = module.networking.vpc_id }
output "private_subnets"  { value = module.networking.private_subnet_ids }
output "nat_ips"          { value = module.networking.nat_public_ips }
output "cluster_name"     { value = module.eks.cluster_name }
output "cluster_endpoint" { value = module.eks.cluster_endpoint }
