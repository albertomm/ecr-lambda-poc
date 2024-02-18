resource "aws_lambda_function" "this" {
  function_name = "the-function"
  role          = aws_iam_role.lambda.arn
  package_type  = "Image"
  image_uri     = var.image_url
  timeout       = 10

  lifecycle {
    ignore_changes = [
      image_uri,
    ]
  }
}

resource "aws_iam_role" "lambda" {
  name               = "the-function-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume.json

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole",
  ]
}

data "aws_iam_policy_document" "lambda_assume" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_lambda_invocation" "this" {
  function_name = aws_lambda_function.this.function_name
  input         = jsonencode({})
}

output "invocation_output" {
  value = jsondecode(aws_lambda_invocation.this.result)
}
