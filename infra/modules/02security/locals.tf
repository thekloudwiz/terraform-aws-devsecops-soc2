# Local variables
locals {
  # Naming convention for resources
  name_prefix = "${var.owner}-${var.project_name}-${terraform.workspace}"

  # Common tags for all resources
  common_tags = {
    Environment = terraform.workspace
    Managed_by  = "terraform"
    Owner       = var.owner
    Project     = var.project_name
  }

  # Resource specific names
  waf_acl_name   = "${local.name_prefix}-waf-acl"
  alb_sg_name    = "${local.name_prefix}-alb-sg"
  ecs_sg_name    = "${local.name_prefix}-ecs-sg"
  lambda_sg_name = "${local.name_prefix}-lambda-sg"
} 