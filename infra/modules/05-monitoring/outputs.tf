# S3 Reports Bucket
output "reports_bucket_name" {
  description = "Name of the S3 bucket for reports"
  value       = aws_s3_bucket.reports_bucket.bucket
}



