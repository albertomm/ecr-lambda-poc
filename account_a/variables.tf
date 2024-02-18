variable "account_b_id" {
  type = string
}


data "aws_caller_identity" "this" {}
data "aws_region" "this" {}
