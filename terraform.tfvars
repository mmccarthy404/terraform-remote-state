local = {
  env    = "prod"
  region = "us-east-1"
}

remote_state = {
  s3_name_prefix             = "tf-state"
  dynamodb_table_name_prefix = "tf-state-lock"
}

github_oidc = {
  url       = "https://token.actions.githubusercontent.com"
  client_id = "sts.amazonaws.com"
  thumbprints = [
    "6938fd4d98bab03faadb97b34396831e3780aea1",
    "1c58a3a8518e8759bf075b76b750d4f2df264fcd"
  ]
}

repos = [
  "aws-core-infra",
  "serverless-bio"
]