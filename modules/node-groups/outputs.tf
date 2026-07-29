output "node_role_arn" {
  description = "IAM role ARN for nodes"
  value       = aws_iam_role.node.arn
}

output "system_node_group_name" {
  value = aws_eks_node_group.system.node_group_name
}

output "application_node_group_name" {
  value = aws_eks_node_group.application.node_group_name
}
