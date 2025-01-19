resource "aws_s3_bucket" "terraform_state" {
  bucket = "${var.resource_prefix}-terraform-state"
}

resource "aws_dynamodb_table" "terraform_locks" {
  name = "${var.resource_prefix}-terraform-locks"

  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
