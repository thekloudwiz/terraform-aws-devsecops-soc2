# KMS Key for CloudWatch logs
resource "aws_kms_key" "cloudwatch_kms" {
  description         = "KMS key for CloudWatch logs encryption"
  enable_key_rotation = true

  # Key policy
  policy = templatefile("${path.root}/policies/kms-policy.json", {
    account_id = data.aws_caller_identity.current.account_id
  })

  tags = merge(local.common_tags, {
    Name        = "${local.name_prefix}-cloudwatch-kms",
    Environment = terraform.workspace,
    Project     = var.project_name,
    Owner       = var.owner
  })

  lifecycle {
    ignore_changes = [policy, tags]
  }
}

# KMS Alias for CloudWatch logs
resource "aws_kms_alias" "cloudwatch_kms_alias" {
  name          = "alias/${local.name_prefix}-cloudwatch-kms"
  target_key_id = aws_kms_key.cloudwatch_kms.key_id
}