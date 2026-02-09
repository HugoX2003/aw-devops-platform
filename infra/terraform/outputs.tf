output "artifacts_bucket_name" {
  value = aws_s3_bucket.artifacts.bucket
}

output "ci_role_arn" {
  value = aws_iam_role.ci_role.arn
}