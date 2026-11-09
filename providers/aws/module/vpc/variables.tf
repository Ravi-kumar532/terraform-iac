variable "name" {
  type        = string
  description = "AWS VPC name; this module provisions the native aws_vpc only, with subnets managed separately."

}
variable "cidr_block" {
  type        = string
  description = "VPC IPv4 CIDR range."

}
variable "tags" {
  type = map(string)
  default = {

  }
  description = "VPC tags."

}
