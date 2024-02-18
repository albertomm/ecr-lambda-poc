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

}
