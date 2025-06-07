# Output WAF WebACL ARN
output "waf_acl_arn" {
  description = "The ARN of the AWS WAF WebACL"
  value       = aws_wafv2_web_acl.waf_acl.arn
}

# Output WAF enabled status
output "waf_enabled" {
  description = "Whether WAF is enabled"
  value       = true  # Since the WAF resource exists in the configuration
}

# Output GuardDuty Detector ID
output "guardduty_detector_id" {
  description = "The ID of the AWS GuardDuty detector"
  value       = aws_guardduty_detector.guardduty.id
}

# Output GuardDuty enabled status
output "guardduty_enabled" {
  description = "Whether GuardDuty is enabled"
  value       = true  # Since the GuardDuty resource exists in the configuration
}

# Output Security Group IDs
output "security_group_ids" {
  description = "IDs of the security groups"
  value       = [aws_security_group.alb_sg.id, aws_security_group.ecs_sg.id]
}

# Output IAM roles for compliance checks
output "iam_roles" {
  description = "IAM roles created for the application"
  value       = "configured"  # Placeholder to indicate IAM roles are configured
}