# Create IAM Role for VPC Flow Logs
resource "aws_iam_role" "vpc_flow_logs_role" {
  name               = "VPCFlowLogsRole"
  assume_role_policy = file("${path.root}/policies/vpc-flow-logs-assume-role-policy.json")
}

# Attach IAM Policy to Allow Logging to CloudWatch
resource "aws_iam_role_policy" "vpc_flow_logs_policy" {
  name = "VPCFlowLogsPolicy"
  role = aws_iam_role.vpc_flow_logs_role.id
  policy = templatefile("${path.root}/policies/vpc-flow-logs-policy.json", {
    log_group_arn = aws_cloudwatch_log_group.vpc_flow_logs.arn
  })
}

# SNS Topic Policy
resource "aws_sns_topic_policy" "default" {
  arn = aws_sns_topic.alerts.arn

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCloudWatchAlarms"
        Effect = "Allow"
        Principal = {
          Service = "cloudwatch.amazonaws.com"
        }
        Action   = "SNS:Publish"
        Resource = aws_sns_topic.alerts.arn
      }
    ]
  })
}

# Create IAM Role for Lambda
resource "aws_iam_role" "lambda_role" {
  name               = "guardduty-lambda-role-${terraform.workspace}"
  assume_role_policy = file("${path.root}/policies/lambda-assume-role-policy.json")
}

# Create IAM Policy for Lambda
resource "aws_iam_policy" "lambda_policy" {
  name        = "GuardDutyLambdaPolicy"
  description = "Policy for Lambda to block IP in AWS WAF"

  policy = templatefile("${path.root}/policies/guardduty-lambda-policy.json", {
    sns_topic_arn = aws_sns_topic.alerts.arn
  })
}

# Attach IAM Policy to Lambda Role
resource "aws_iam_role_policy_attachment" "attach_lambda_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

# Add VPC permissions to Lambda role
resource "aws_iam_role_policy_attachment" "lambda_vpc_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = data.aws_iam_policy.lambda_vpc_policy.arn
}

# Create Lambda Permission for EventBridge
resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.guardduty_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.guardduty_event_rule.arn
}