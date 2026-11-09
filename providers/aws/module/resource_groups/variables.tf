variable "name" {
  type        = string
  description = "AWS Resource Groups group using aws_resourcegroups_group and tag filters; this is not a resource container."
}
variable "tag_key" {
  type        = string
  default     = "Environment"
  description = "Tag key used to select resources."
}
variable "tag_value" {
  type        = string
  description = "Tag value used to select resources."
}
variable "tags" {
  type = map(string)
  default = {

  }
  description = "Resource group tags."
}
