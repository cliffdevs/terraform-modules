variable "service_domain_name" {
  type = string
  description = "FQDN of your service domain"
}

variable "certificate_arn" {
  type = string
  description = "The ARN for your AWS ACM Certificate to use for validating domain"
}

variable "zone_id" {
  type = string
  description = "The Route 53 Hosted Zone Id for this endpoint"
}

variable "region" {
  type = string
  description = "The AWS Region"
}

variable "health_check_id" {
  type = string
  description = "The parent health check id to revoke DNS for this record if unhealthy"
  default = null
}
