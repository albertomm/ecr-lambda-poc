resource "aws_iam_role" "updater" {
  name               = "the-function-updater"
  assume_role_policy = data.aws_iam_policy_document.updater_assume.json

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole",
  ]

  inline_policy {
    name   = "ecr"
    policy = data.aws_iam_policy_document.updater_ecr.json
  }

  inline_policy {
    name   = "lambda"
    policy = data.aws_iam_policy_document.updater_lambda.json
  }

  inline_policy {
    name   = "kms"
    policy = data.aws_iam_policy_document.updater_kms.json
  }
}

data "aws_iam_policy_document" "updater_assume" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.account_a_id}:root", ]
    }
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "updater_ecr" {
  statement {
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:ListImages",
      "ecr:DescribeImages",
      "ecr:BatchGetImage",
      "ecr:DescribeRepositories",
      "ecr:GetRepositoryPolicy",
    ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "updater_lambda" {
  statement {
    actions = [
      "lambda:UpdateFunctionCode",
      "lambda:GetFunctionConfiguration",
      "lambda:InvokeFunction",
    ]
    resources = [aws_lambda_function.this.arn]
  }
}

data "aws_iam_policy_document" "updater_kms" {
  statement {
    actions   = ["kms:*"]
    resources = ["*"]
  }
}
