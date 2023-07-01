resource "aws_iam_openid_connect_provider" "github" {
  url             = var.github_oidc.url
  client_id_list  = [var.github_oidc.client_id]
  thumbprint_list = var.github_oidc.thumbprints

  lifecycle {
    prevent_destroy = true
  }
}