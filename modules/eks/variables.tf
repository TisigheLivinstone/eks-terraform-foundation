variable "project_name" {
  description = "Project name used as a prefix"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, staging, production)"
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.36"
}

variable "vpc_id" {
  description = "VPC ID from the networking module output"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs from the networking module output — nodes go here"
  type        = list(string)
}

variable "allowed_cidrs" {
  description = "CIDRs allowed to reach the public API endpoint — restrict to your IP"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
