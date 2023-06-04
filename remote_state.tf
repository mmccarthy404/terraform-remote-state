resource "aws_s3_bucket" "state" {
  bucket = join("-", [
    var.remote_state.s3_name_prefix,
    var.local.region,
    data.aws_caller_identity.current.account_id,
    var.local.env
  ])

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_versioning" "state" {
  bucket = aws_s3_bucket.state.id

  versioning_configuration {
    status = "Enabled"
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_dynamodb_table" "state_lock" {
  name = join("-", [
    var.remote_state.dynamodb_table_name_prefix,
    var.local.env
  ])
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  lifecycle {
    prevent_destroy = true
  }
}