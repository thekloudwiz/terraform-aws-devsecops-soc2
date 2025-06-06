# Fetch current caller identity
data "aws_caller_identity" "current" {}

# Create ZIP file for Lambda function
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/lambda.py"
  output_path = "${path.module}/lambda_function.zip"
}

# Get VPC ID
data "aws_ssm_parameter" "vpc_id" {
  name = "/${var.owner}/${var.project_name}/${terraform.workspace}/vpc_id"
}

# Fetch Subnet IDs from SSM Parameter Store
data "aws_ssm_parameter" "public_subnet_ids" {
  name = "/${var.owner}/${var.project_name}/${terraform.workspace}/public_subnet_ids"
}

# Fetch Lambda Security Group ID from SSM Parameter Store
data "aws_ssm_parameter" "lambda_sg_id" {
  name = "/${var.owner}/${var.project_name}/${terraform.workspace}/lambda_sg_id"
}

# Get ALB ARN
data "aws_lb" "alb" {
  name = "${local.name_prefix}-alb"
}

# Fetch ECS Cluster Name
data "aws_ecs_cluster" "ecs_cluster" {
  cluster_name = local.ecs_cluster_name
}

# Fetch SNS Topic ARN
data "aws_sns_topic" "alerts" {
  name = "${local.name_prefix}-backend-alerts"
}

# Fetch WAF ACL ID
data "aws_ssm_parameter" "waf_acl_id" {
  name = "/${var.owner}/${var.project_name}/${terraform.workspace}/waf_acl_id"
}

# Fetch GuardDuty Detector ID
data "aws_ssm_parameter" "guardduty_detector_id" {
  name = "/${var.owner}/${var.project_name}/${terraform.workspace}/guardduty_detector_id"
}

# Fetch VPC Permissions for Lambda
data "aws_iam_policy" "lambda_vpc_policy" {
  name = "AWSLambdaVPCAccessExecutionRole"
}

# Fetch application logs group
data "aws_cloudwatch_log_group" "app_logs" {
  name = "/aws/ecs/app-${local.ecs_cluster_name}-app-logs"
}