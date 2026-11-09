variable "name" {
  type        = string
  description = "Amazon EKS cluster name for the native aws_eks_cluster and managed aws_eks_node_group."
}
variable "cluster_role_arn" {
  type        = string
  description = "Caller-provided EKS cluster IAM role ARN."
}
variable "kubernetes_version" {
  type        = string
  default     = null
  description = "Optional supported Kubernetes version."
}
variable "subnet_ids" {
  type        = list(string)
  description = "Existing private subnet IDs across multiple Availability Zones."
}
variable "endpoint_public_access" {
  type        = bool
  default     = false
  description = "Enable public Kubernetes API endpoint access intentionally."
}
variable "security_group_ids" {
  type        = list(string)
  default     = []
  description = "Additional cluster security group IDs."
}
variable "kms_key_arn" {
  type        = string
  description = "Customer-managed KMS key ARN for Kubernetes secret encryption."
}
variable "tags" {
  type = map(string)
  default = {

  }
  description = "Cluster tags."
}

variable "node_role_arn" {
  type        = string
  description = "Caller-provided EKS worker node IAM role ARN."

}
variable "node_instance_types" {
  type        = list(string)
  default     = ["m6i.large"]
  description = "Managed node group instance types."

}
variable "node_min_size" {
  type        = number
  default     = 2
  description = "Minimum managed worker nodes."

}
variable "node_desired_size" {
  type        = number
  default     = 3
  description = "Desired managed worker nodes."

}
variable "node_max_size" {
  type        = number
  default     = 8
  description = "Maximum managed worker nodes."

}
