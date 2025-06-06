# Fetch current caller identity
data "aws_caller_identity" "current" {}

# Add SSM Parameter data sources
data "aws_ssm_parameter" "ecs_sg_id" {
  name = "/${var.owner}/${var.project_name}/${terraform.workspace}/ecs_sg_id"
}

# Fetch Lambda Security Group ID from SSM Parameter Store
data "aws_ssm_parameter" "lambda_sg_id" {
  name = "/${var.owner}/${var.project_name}/${terraform.workspace}/lambda_sg_id"
}

# Fetch VPC ID from SSM Parameter Store
data "aws_ssm_parameter" "vpc_id" {
  name = "/${var.owner}/${var.project_name}/${terraform.workspace}/vpc_id"
}

# Fetch Subnet IDs from SSM Parameter Store
data "aws_ssm_parameter" "public_subnet_ids" {
  name = "/${var.owner}/${var.project_name}/${terraform.workspace}/public_subnet_ids"
}

data "aws_ssm_parameter" "private_subnet_ids" {
  name = "/${var.owner}/${var.project_name}/${terraform.workspace}/private_subnet_ids"
}

# Fetch ALB Target Group ARN from SSM Parameter Store
data "aws_ssm_parameter" "alb_target_group_arn" {
  name = "/${var.owner}/${var.project_name}/${terraform.workspace}/alb_target_group_arn"
}

# # Fetch SNS Topic ARN from SSM Parameter Store
# data "aws_ssm_parameter" "sns_topic_arn" {
#   name = "/${var.owner}/${var.project_name}/${terraform.workspace}/sns_topic_arn"
# }

# Fetch Amazon ECS Task Execution Role Policy
data "aws_iam_policy" "ecs_task_execution_policy" {
  name = "AmazonECSTaskExecutionRolePolicy"
}

# Fetch Amazon SSM ReadOnlyAccess Policy
data "aws_iam_policy" "ssm_read_only" {
  name = "AmazonSSMReadOnlyAccess"
}

# # Fetch SNS Topic ARN
# data "aws_sns_topic" "alerts" {
#   name = "${local.name_prefix}-backend-alerts"
# }

# Fetch Alb ARN suffix
data "aws_lb" "alb" {
  name = "${local.name_prefix}-alb"
}

# Fetch WAF ACL ID
data "aws_ssm_parameter" "waf_acl_id" {
  name = "/${var.owner}/${var.project_name}/${terraform.workspace}/waf_acl_id"
}

# # Fetch GuardDuty Detector ID
# data "aws_ssm_parameter" "guardduty_detector_id" {
#   name = "/${local.name_prefix}-${terraform.workspace}/guardduty_detector_id"
# }








