output "s3_bucket_name" {
  value = aws_s3_bucket.vineet_s3.bucket
}

output "rds_endpoint" {
  value = aws_db_instance.vineet_rds.endpoint
}

output "lambda_role_name" {
  value = aws_iam_role.vineet_lambda_role.name
}
