output "repository_url" {
  value = aws_ecr_repository.this.repository_url
}

output "ecr_registry" {
  value = trimsuffix(
    aws_ecr_repository.this.repository_url,
    "/${aws_ecr_repository.this.name}",
  )
}

output "region" {
  value = data.aws_region.this.name
}
