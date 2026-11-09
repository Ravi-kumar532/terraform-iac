output "arn" {
  value = aws_eks_cluster.this.arn
}
output "endpoint" {
  value = aws_eks_cluster.this.endpoint
}
output "certificate_authority" {
  value     = aws_eks_cluster.this.certificate_authority[0].data
  sensitive = true
}

output "node_group_arn" {
  value = aws_eks_node_group.this.arn
}
