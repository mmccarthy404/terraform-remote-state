local = {
  env    = "prod"
  region = "us-east-1"
}

remote_state = {
  s3_name_prefix             = "tf-state"
  dynamodb_table_name_prefix = "tf-state-lock"
}

github_oidc = {
  url        = "https://token.actions.githubusercontent.com"
  client_id  = "sts.amazonaws.com"
  thumbprint = "6938fd4d98bab03faadb97b34396831e3780aea1"
}

repos = []