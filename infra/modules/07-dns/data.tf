# Create Data Source for ALB DNS name
data "aws_ssm_parameter" "alb_dns_name" {
  name = "/${var.owner}/${var.project_name}/${terraform.workspace}/alb_dns_name"
}

# Fetch ALB ZONE ID from SSM Parameter Store
data "aws_ssm_parameter" "alb_zone_id" {
  name = "/${var.owner}/${var.project_name}/${terraform.workspace}/alb_zone_id"
}

# Create Data Source for ALB Zone ID
data "aws_route53_zone" "primary" {
  name = var.primary_domain_name
}