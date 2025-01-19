resource "aws_iam_role" "lambda_execution_role" {
  name = "${var.resource_prefix}_lambda_role"

  assume_role_policy = templatefile("${path.module}/assume_role_policy.json", {})
  permissions_boundary = var.iam_permission_boundary_arn
}

resource "aws_iam_role_policy" "lambda_logger_policy" {
  name = "${var.resource_prefix}_lambda_logger_policy"
  role = aws_iam_role.lambda_execution_role.id

  policy = templatefile("${path.module}/logger_policy.json", {})
}

resource "aws_iam_role_policy" "lambda_xray_policy" {
  name = "${var.resource_prefix}_lambda_xray_policy"
  role = aws_iam_role.lambda_execution_role.id

  policy = templatefile("${path.module}/xray_policy.json", {})
}
