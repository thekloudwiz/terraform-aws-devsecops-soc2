# Get VPC ID from SSM Parameter Store
data "aws_ssm_parameter" "vpc_id" {
  name = "/${var.owner}/${var.project_name}/${terraform.workspace}/vpc_id"
}

# # Get Route 53 Hosted Zone
# data "aws_route53_zone" "primary" {
#   name       = var.primary_domain_name
#   private_zone = false
# }

# # Get IAM Certificate
# data "aws_iam_server_certificate" "iam_cert" {
#   name = var.iam_cert_name
# }

# # Get ACM Certificate
# data "aws_acm_certificate" "acm_cert" {
#   domain = var.wildcard_domain_name
#   statuses = ["ISSUED"]
#   types    = ["AMAZON_ISSUED"]
# }
