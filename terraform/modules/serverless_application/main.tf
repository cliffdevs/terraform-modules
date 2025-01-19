locals {
  lambda_md5 = filemd5(var.lambda_code_zip)
}

module "lambda_iam_role" {
  source = "../lambda_execution_role"

  resource_prefix = "${var.resource_prefix}-${var.region}"
  iam_permission_boundary_arn = var.iam_permission_boundary_arn
}

module "custom_domain" {
  source = "../custom_domain"

  certificate_arn = var.certificate_arn
  service_domain_name = var.service_domain_name
  region = var.region
  zone_id = var.zone_id
  health_check_id = var.health_check_id
}

module "api_gateway" {
  source = "../api_gateway"

  application_name = var.app_name
  domain_name = var.service_domain_name
  lambda_invoke_arn = aws_lambda_function.serverless_application.invoke_arn
  lambda_md5 = local.lambda_md5
  lambda_function_name = aws_lambda_function.serverless_application.function_name
  description = var.app_description
  lambda_timeout_seconds = 29
  region = var.region
  api_key_required = var.api_key_required
  cognito_authorizer_settings = var.cognito_authorizer_settings
}

resource "aws_s3_bucket" "lambda_bucket" {
  bucket = var.lambda_bucket_name
}

resource "aws_s3_bucket_object" "lambda_code" {
  key = var.app_name
  bucket = aws_s3_bucket.lambda_bucket.id
  source = var.lambda_code_zip
  etag = local.lambda_md5
}

resource "aws_lambda_function" "serverless_application" {
  function_name = var.resource_prefix
  role = module.lambda_iam_role.lambda_execution_role_arn
  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key = aws_s3_bucket_object.lambda_code.id
  source_code_hash = local.lambda_md5
  handler = var.handler_function
  runtime = var.runtime
  timeout = var.timeout
  memory_size = var.memory_size
  publish = true

  tracing_config {
    mode = "Active"
  }

  environment {
    variables = var.env_vars
  }
}
