variable "region" {
  type = string
  description = "The AWS Region"
}

variable "application_name" {
  type = string
  description = "name of your app"
}

variable "description" {
  type = string
  description = "Description of your app"
}

variable "stage_name" {
  type = string
  description = "The name of your API GW Stage to update"
  default = "app_stage"
}

variable "lambda_function_name" {
  type = string
  description = "The name of the lambda function"
}

variable "lambda_timeout_seconds" {
  type = number
  description = "The seconds for the API GW to wait on lambda to respond before timing out. Always make it longer than your actual timeout and shorter than 30"
}

variable "domain_name" {
  type = string
  description = "The domain name fo rAPI GW to use"
}

variable "lambda_md5" {
  type = string
  description = "MD5 of your function code to detect if redeployment is necessary"
}

variable "lambda_invoke_arn" {
  type = string
  description = "ARN of the lambda to invoke"
}

variable "api_key_required" {
  type = bool
  description = "True if you want to reject requests without an api key"
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