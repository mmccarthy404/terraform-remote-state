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