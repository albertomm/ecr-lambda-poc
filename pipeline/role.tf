resource "aws_iam_role" "this" {
  name               = "the-function-pipeline"
  assume_role_policy = data.aws_iam_policy_document.assume.json

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser",
  ]

  inline_policy {
    name   = "AllowFunctionUpdate"
    policy = data.aws_iam_policy_document.function_update.json
  }
}

data "aws_iam_policy_document" "assume" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.this.account_id}:root"]
    }
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "function_update" {
  statement {
    sid       = "AllowAssumingUpdaterRole"
    actions   = ["sts:AssumeRole"]
    resources = [var.updater_role_arn]
  }
}
