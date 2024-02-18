variable "account_b_id" {
  type = string
}

variable "updater_role_arn" {
  type = string
}

data "aws_caller_identity" "this" {}
data "aws_region" "this" {}
