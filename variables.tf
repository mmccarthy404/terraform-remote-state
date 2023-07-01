variable "local" {
  type = object({
    env    = string
    region = string
  })
}

variable "remote_state" {
  type = object({
    s3_name_prefix             = string
    dynamodb_table_name_prefix = string
  })
}

variable "github_oidc" {
  type = object({
    url         = string
    client_id   = string
    thumbprints = list(string)
  })
}

variable "repos" {
  type = list(string)
}