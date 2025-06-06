# Get Route 53 Hosted Zone
data "aws_route53_zone" "primary" {
  name         = var.primary_domain_name
  private_zone = false
}

# Get AWS account info
data "aws_caller_identity" "current" {}
data "aws_elb_service_account" "main" {}

# Retrieve ALB SG ID from SSM Parameter Store
data "aws_ssm_parameter" "alb_sg_id" {
  name = "/${var.owner}/${var.project_name}/${terraform.workspace}/alb_sg_id"
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

# Fetch WAF ACL ARN from SSM Parameter Store
data "aws_ssm_parameter" "waf_acl_arn" {
  name = "/${var.owner}/${var.project_name}/${terraform.workspace}/waf_acl_arn"
}

# Get ACM Certificate
data "aws_acm_certificate" "acm_cert" {
  domain   = var.wildcard_domain_name
  statuses = ["ISSUED"]
  types    = ["AMAZON_ISSUED"]
}