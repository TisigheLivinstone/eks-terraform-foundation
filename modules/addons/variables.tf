variable "cluster_name" {
  type = string
}

variable "region" {
  type = string
}

variable "lb_controller_role_arn" {
  type = string
}

variable "cluster_autoscaler_role_arn" {
  type = string
}

variable "vpc_id" {
  description = "VPC ID — passed explicitly to the Load Balancer Controller"
  type        = string
}