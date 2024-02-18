output "function_arn" {
  value = aws_lambda_function.this.arn
}

output "updater_role_arn" {
  value = aws_iam_role.updater.arn
}
