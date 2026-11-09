variable "name" {
  type        = string
  description = "AWS subnet name for the native aws_subnet resource; it does not create or modify a VPC."
}
variable "vpc_id" {
  type        = string
  description = "Existing VPC ID."
}
variable "cidr_block" {
  type        = string
  description = "Subnet IPv4 CIDR range."
}
variable "availability_zone" {
  type        = string
  description = "Availability zone."
}
variable "tags" {
  type = map(string)
  default = {

  }
  description = "Subnet tags."
}
