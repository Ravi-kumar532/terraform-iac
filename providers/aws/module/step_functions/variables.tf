variable "name" {
  type        = string
  description = "Step Functions state machine name for the native aws_sfn_state_machine."
}
variable "tags" {
  type = map(string)
  default = {

  }
  description = "Resource tags."
}
variable "execution_role_arn" {
  type        = string
  description = "Caller-provided Step Functions execution role ARN with least-privilege permissions."
}
variable "definition" {
  type        = string
  description = "Amazon States Language JSON; reference secrets from managed secret stores, never embed them."
}
variable "type" {
  type        = string
  default     = "STANDARD"
  description = "Workflow type: STANDARD or EXPRESS."
}
variable "log_destination" {
  type        = string
  description = "CloudWatch Logs log group ARN ending in :*; configure log retention separately."
}
