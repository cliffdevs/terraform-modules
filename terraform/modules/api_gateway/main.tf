resource "aws_api_gateway_rest_api" "rest_api" {
  name = "${var.application_name}-api"
  description = var.description
  disable_execute_api_endpoint = true
}

resource "aws_api_gateway_resource" "resource" {
  parent_id   = aws_api_gateway_rest_api.rest_api.root_resource_id
  path_part   = "{proxy+}"
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
}

resource "aws_api_gateway_authorizer" "cognito_authorizer" {
  count = var.cognito_authorizer_settings.cognito_enabled ? 1 : 0

  name = "${var.lambda_function_name}-cognito-authorizer"
  type = "COGNITO_USER_POOLS"
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  provider_arns = var.cognito_authorizer_settings.cognito_user_pool_arns
}

resource "aws_api_gateway_method" "method" {
  api_key_required = var.api_key_required
  authorization =  var.cognito_authorizer_settings.cognito_enabled ? "COGNITO_USER_POOLS" : "NONE"
  authorizer_id = var.cognito_authorizer_settings.cognito_enabled ? aws_api_gateway_authorizer.cognito_authorizer[0].id : null
  http_method = "ANY"
  resource_id = aws_api_gateway_resource.resource.id
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
}

resource "aws_api_gateway_integration" "integration" {
  http_method = aws_api_gateway_method.method.http_method
  integration_http_method = "POST"
  resource_id = aws_api_gateway_resource.resource.id
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  type        = "AWS_PROXY"
  uri = var.lambda_invoke_arn

  depends_on = [
    aws_api_gateway_method.method
  ]
}

resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id

  triggers = {
    redeployment = var.lambda_md5
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_api_gateway_method.method,
    aws_api_gateway_integration.integration
  ]
}

resource "aws_api_gateway_stage" "stage" {
  deployment_id = aws_api_gateway_deployment.deployment.id
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  stage_name    = var.stage_name

  depends_on = [
    aws_api_gateway_deployment.deployment
  ]
}

resource "aws_lambda_permission" "apig_to_lambda" {
  statement_id = "AllowExecutionFromAPIGateway"
  action = "lambda:invokeFunction"
  function_name = var.lambda_function_name
  principal = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.rest_api.execution_arn}/*/*/*"
}

resource "aws_api_gateway_base_path_mapping" "base_path" {
  api_id = aws_api_gateway_rest_api.rest_api.id
  domain_name = var.domain_name
  stage_name = var.stage_name

  depends_on = [
    aws_api_gateway_stage.stage
  ]
}
