output "execution_role_arn" {
  value = module.lambda_iam_role.lambda_execution_role_arn
}

output "execution_role_id" {
  value = module.lambda_iam_role.lambda_execution_role_id
}

output "log_group" {
  value = "/aws/lambda/${aws_lambda_function.serverless_application.function_name}"
}

output "api_gateway_api_id" {
  value = module.api_gateway.api_gateway_api_id
}

output "api_gateway_api_stage" {
  value = module.api_gateway.api_gateway_api_stage
}

output "api_host" {
  value = module.custom_domain.domain_name
}
