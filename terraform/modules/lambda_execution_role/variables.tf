variable "resource_prefix" {
  type = string
  description = "Prefix for the role/policy names"
}

variable "iam_permission_boundary_arn" {
  type = string
  description = "ARN for permission boundary"
  default = null
}