# # Store ACM certificate ARN in SSM
# resource "aws_ssm_parameter" "certificate_arn" {
#   name  = "/${var.owner}/${var.project_name}/${terraform.workspace}/certificate_arn"
#   type  = "SecureString"
#   value = data.aws_iam_server_certificate.iam_cert.arn
#   tags  = local.common_tags

#   #checkov:skip=CKV2_AWS_34: "AWS SSM Parameter should be Encrypted"
#   #checkov:skip=CKV_AWS_337: "Ensure SSM parameters are using KMS CMK"
# }

# # Store Imported Certificate ARN in SSM
# resource "aws_ssm_parameter" "imported_cert_arn" {
#   name  = "/${var.owner}/${var.project_name}/${terraform.workspace}/imported_cert_arn"
#   type  = "SecureString"
#   value = data.aws_iam_server_certificate.iam_cert.arn
#   tags  = local.common_tags

#   #checkov:skip=CKV2_AWS_34: "AWS SSM Parameter should be Encrypted"
#   #checkov:skip=CKV_AWS_337: "Ensure SSM parameters are using KMS CMK"
# }

# Store WAF ACL ARN in SSM
resource "aws_ssm_parameter" "waf_acl_arn" {
  name  = "/${var.owner}/${var.project_name}/${terraform.workspace}/waf_acl_arn"
  type  = "SecureString"
  value = aws_wafv2_web_acl.waf_acl.arn
  tags  = local.common_tags

  lifecycle {
    ignore_changes = [value]
  }

  #checkov:skip=CKV2_AWS_34: "AWS SSM Parameter should be Encrypted"
  #checkov:skip=CKV_AWS_337: "Ensure SSM parameters are using KMS CMK"
}

# Store WAF ACL ID in SSM
resource "aws_ssm_parameter" "waf_acl_id" {
  name  = "/${var.owner}/${var.project_name}/${terraform.workspace}/waf_acl_id"
  type  = "SecureString"
  value = aws_wafv2_web_acl.waf_acl.id
  tags  = local.common_tags

  lifecycle {
    ignore_changes = [value]
  }

  #checkov:skip=CKV2_AWS_34: "AWS SSM Parameter should be Encrypted"
  #checkov:skip=CKV_AWS_337: "Ensure SSM parameters are using KMS CMK"
}

# Store GuardDuty Detector ID in SSM
resource "aws_ssm_parameter" "guardduty_detector_id" {
  name  = "/${var.owner}/${var.project_name}/${terraform.workspace}/guardduty_detector_id"
  type  = "SecureString"
  value = aws_guardduty_detector.guardduty.id
  tags  = local.common_tags

  lifecycle {
    ignore_changes = [value]
  }

  #checkov:skip=CKV2_AWS_34: "AWS SSM Parameter should be Encrypted"
  #checkov:skip=CKV_AWS_337: "Ensure SSM parameters are using KMS CMK"
}

# Store ECS Security Group ID in SSM
resource "aws_ssm_parameter" "ecs_sg_id" {
  name       = "/${var.owner}/${var.project_name}/${terraform.workspace}/ecs_sg_id"
  type       = "String"
  value      = aws_security_group.ecs_sg.id
  tags       = local.common_tags
  depends_on = [aws_security_group.ecs_sg]

  #checkov:skip=CKV2_AWS_34: "AWS SSM Parameter should be Encrypted"
}

# Store ALB Security Group ID in SSM
resource "aws_ssm_parameter" "alb_sg_id" {
  name       = "/${var.owner}/${var.project_name}/${terraform.workspace}/alb_sg_id"
  type       = "String"
  value      = aws_security_group.alb_sg.id
  depends_on = [aws_security_group.alb_sg]

  tags = local.common_tags

  #checkov:skip=CKV2_AWS_34: "AWS SSM Parameter should be Encrypted"
}

# Store Lambda Security Group ID in SSM
resource "aws_ssm_parameter" "lambda_sg_id" {
  name       = "/${var.owner}/${var.project_name}/${terraform.workspace}/lambda_sg_id"
  type       = "String"
  value      = aws_security_group.lambda_sg.id
  depends_on = [aws_security_group.lambda_sg]

  tags = local.common_tags

  #checkov:skip=CKV2_AWS_34: "AWS SSM Parameter should be Encrypted"
}





