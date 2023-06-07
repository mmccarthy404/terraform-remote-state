local = {
  env    = "prod"
  region = "us-east-1"
}

remote_state = {
  s3_name_prefix             = "tf-state"
  dynamodb_table_name_prefix = "tf-state-lock"
}

repo_roles = [
  {
    repo     = "terraform-remote-state"
    policies = ["arn:aws:iam::aws:policy/AdministratorAccess"]
  }
]