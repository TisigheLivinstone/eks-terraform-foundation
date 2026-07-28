output "vpc_id" {
  value = module.networking.vpc_id
}

output "private_subnets" {
  value = module.networking.private_subnet_ids
}

output "public_subnets" {
  value = module.networking.public_subnet_ids
}

output "nat_ips" {
  value       = module.networking.nat_public_ips
  description = "Elastic IPs of NAT Gateways"
}
