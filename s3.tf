resource "aws_s3_bucket" "test" {
  bucket = join("-", [
    "test",
    var.local.region,
    data.aws_caller_identity.current.account_id,
    var.local.env
  ])
}