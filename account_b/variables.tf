variable "image_url" {
  type = string
}

variable "account_a_id" {
  type = string
}

data "aws_caller_identity" "this" {}
data "aws_region" "this" {}
