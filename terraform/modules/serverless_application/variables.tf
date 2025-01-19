variable "lambda_bucket_name" {
  type = string
  description = "AWS S3 Bucket Name for storing built lambda zip files"
}

variable "lambda_code_zip" {
  type = string
  description = "Reference to your AWS Lambda code zip file. Recommend using path.cwd var to build a relative path to your directory"
}

variable "app_name" {
  type = string
  description = "Friendly reference to your app name"
}

variable "app_description" {
  type = string
  description = "Description of app"
}

variable "handler_function" {
  type = string
  description = "Name of your handler function so AWS can invoke your lambda"
}

variable "runtime" {
  type = string
  description = "AWS Function runtime environment"
}

variable "timeout" {
  type = number
  description = "AWS Function timeout"
  default = 28
}

variable "memory_size" {
  type = number
  description = "Memory to allocate for function in MB"
  default = 2048
}

variable "env_vars" {
  type = map(string)
  description = "Map of environment variables to apply for your function"
}

variable "service_domain_name" {
  type = string
  description = "FQDN for your service domain, ex: myapp.domain.com"
}

variable "certificate_arn" {
  type = string
  description = "The ARN for the ACM certificate for the domain"
}

variable "zone_id" {
  type = string
  description = "The Route 53 hosted zone id"
}

variable "region" {
  type = string
  description = "AWS Region"
}

variable "iam_permission_boundary_arn" {
  type = string
  description = "arn for permission boundar"
  default = null
}

variable "health_check_id" {
  type = string
  description = "The parent health check id to revoke dns for this record if unhealthy"
  default = null
}

variable "api_key_required" {
  type = bool
  description = "True if you want to reject requests without an api key"
}

variable "resource_prefix" {
  type = string
  description = "The resource prefix, format 'tenant-app'"
}

variable "cognito_authorizer_settings" {
  type = object({
    cognito_enabled: bool,
    cognito_user_pool_arns: optional(set(string)),
  })
  description = "The configuration to enable Cognito User Pool Authorizer for the API. If enabled, you must provide the user pool arn. Defaults to disabled"
  default = {
    cognito_enabled: false,
  }
}
