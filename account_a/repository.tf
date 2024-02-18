locals {
  pull_actions = [
    "ecr:BatchCheckLayerAvailability",
    "ecr:GetDownloadUrlForLayer",
    "ecr:ListImages",
    "ecr:DescribeImages",
    "ecr:BatchGetImage",
    "ecr:DescribeRepositories",
    "ecr:GetRepositoryPolicy",
  ]
}

resource "aws_ecr_repository" "this" {
  name                 = "ecr-lambda-poc"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "KMS"
    kms_key         = aws_kms_key.this.arn
  }
}

resource "aws_ecr_repository_policy" "this" {
  repository = aws_ecr_repository.this.name
  policy     = data.aws_iam_policy_document.repository.json

  depends_on = [aws_ecr_repository.this]
}

data "aws_iam_policy_document" "repository" {

  statement {
    sid = "AllowPullFromOtherAccounts"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.account_b_id}:root"]
    }
    actions = local.pull_actions
  }

  statement {
    sid = "AllowPullFromLambda"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    condition {
      test     = "StringLike"
      variable = "aws:SourceArn"
      values = [
        "arn:aws:lambda:${data.aws_region.this.name}:${var.account_b_id}:function:*",
      ]
    }
    actions = local.pull_actions
  }
}
