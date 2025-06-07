# Monitoring outputs
output "cloudwatch_log_group_name" {
  description = "Name of the CloudWatch log group"
  value       = aws_cloudwatch_log_group.ecs_logs.name
}

output "sns_topic_arn" {
  description = "ARN of the SNS topic"
  value       = aws_sns_topic.alerts.arn
}

# Output SNS topic Name
output "sns_topic_name" {
  description = "Name of the SNS topic"
  value       = aws_sns_topic.alerts.name
}

output "reports_bucket_name" {
  description = "Name of the S3 bucket for reports"
  value       = aws_s3_bucket.reports_bucket.bucket
}