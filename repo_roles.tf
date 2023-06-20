locals {
  github_username = "mmccarthy404"
  this_repo       = "terraform-remote-state"
}

resource "aws_iam_role" "this_repo" {
  name = "github-oidc-${local.this_repo}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = "${aws_iam_openid_connect_provider.github.arn}"
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          "StringEquals" = {
            "token.actions.githubusercontent.com:aud" = "${var.github_oidc.client_id}"
          }
          "StringLike" = {
            "token.actions.githubusercontent.com:sub" = "repo:${local.github_username}/${local.this_repo}:*"
          }
        }
      }
    ]
  })

  inline_policy {
    name = "github-oidc-${local.this_repo}"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Effect   = "Allow"
          Action   = "*"
          Resource = "*"
        }
      ]
    })
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_iam_role" "repos" {
  for_each = toset(var.repos)
  name     = "github-oidc-${each.key}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = "${aws_iam_openid_connect_provider.github.arn}"
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          "StringEquals" = {
            "token.actions.githubusercontent.com:aud" = "${var.github_oidc.client_id}"
          }
          "StringLike" = {
            "token.actions.githubusercontent.com:sub" = "repo:${local.github_username}/${each.key}:*"
          }
        }
      }
    ]
  })

  inline_policy {
    name = "github-oidc-${each.key}"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Effect   = "Allow"
          Action   = "*"
          Resource = "*"
        }
      ]
    })
  }
}