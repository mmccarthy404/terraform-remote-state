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
        },
        {
          Effect = "Deny"
          Action = "*"
          Resource = [
            "${aws_s3_bucket.state.arn}",
            "${aws_s3_bucket.state.arn}/*"
          ]
          Condition = {
            "StringNotEquals" = {
              "s3:prefix" = "${each.key}"
            }
          }
        },
        {
          Effect   = "Deny"
          Action   = "*"
          Resource = "${aws_dynamodb_table.state_lock.arn}"
          Condition = {
            "StringNotEquals" = {
              "dynamodb:LeadingKeys" = "${aws_s3_bucket.state.arn}/${each.key}-md5"
            }
          }
        }
      ]
    })
  }
}