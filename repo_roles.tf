locals {
  github_username = "mmccarthy404"
}

resource "aws_iam_role" "repos" {
  for_each = toset(var.repos)
  name     = "github-oidc-${each.key}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = "${aws_iam_openid_connect_provider.github.arn}"
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          "StringEquals" = {
            "token.actions.githubusercontent.com:aud" = "${var.github_oidc.client_id}"
          },
          "StringLike" = {
            "token.actions.githubusercontent.com:sub" = "repo:${local.github_username}/${each.key}:*"
          }
        }
      }
    ]
  })

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AdministratorAccess"
  ]
}