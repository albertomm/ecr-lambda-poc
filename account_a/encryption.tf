resource "aws_kms_key" "this" {
  description = "ecr-lambda-poc"
}

resource "aws_kms_key_policy" "this" {
  key_id = aws_kms_key.this.key_id
  policy = data.aws_iam_policy_document.kms_key.json
}

data "aws_iam_policy_document" "kms_key" {
  statement {
    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.this.account_id}:root",
      ]
    }
    actions   = ["kms:*"]
    resources = ["*"]
  }

  statement {
    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${var.account_b_id}:root",
      ]
    }
    actions   = ["kms:Decrypt"]
    resources = ["*"]
  }

  statement {
    sid = "LambdaPermissions"
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
    actions   = ["kms:Decrypt"]
    resources = ["*"]
  }
}
