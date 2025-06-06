# GitHub Actions Secret Outputs
# Run 'terraform output' to get these values for your act-secrets.env file

# IAM Role for GitHub Actions
output "github_actions_role_arn" {
  description = "ARN of the IAM role for GitHub Actions"
  value       = module.github_oidc.github_actions_role_arn
}

# ECR Repository
output "ecr_repository_url" {
  description = "URL of the ECR repository"
  value       = module.compute.ecr_repository_url
}

output "ecr_repository_name" {
  description = "Name of the ECR repository"
  value       = module.compute.ecr_repository_name
}

# ECS Configuration
output "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  value       = module.compute.ecs_cluster_name
}

output "ecs_service_name" {
  description = "Name of the ECS service"
  value       = module.compute.ecs_service_name
}

output "ecs_task_family" {
  description = "Family name of the ECS task definition"
  value       = module.compute.ecs_task_family
}

# S3 Reports Bucket
output "reports_bucket_name" {
  description = "Name of the S3 bucket for reports"
  value       = module.monitoring.reports_bucket_name
}

# AWS Region
output "aws_region" {
  description = "AWS region where resources are deployed"
  value       = var.primary_region
}

# GitHub Repository Info
output "github_repository" {
  description = "GitHub repository name for SSM parameter paths"
  value       = "${var.owner}/${var.project_name}"
}

# # Command to extract all secrets for act-secrets.env
# output "act_secrets_command" {
#   description = "Command to generate act-secrets.env file"
#   value       = <<-EOT
#     # Run this command to generate your act-secrets.env file:
#     echo "# GitHub Token - Create a Personal Access Token at https://github.com/settings/tokens" > .github/act-secrets.env
#     echo "GITHUB_TOKEN=ghp_your_github_personal_access_token" >> .github/act-secrets.env
#     echo "" >> .github/act-secrets.env
#     echo "# SonarCloud Tokens - Get these from your SonarCloud account" >> .github/act-secrets.env
#     echo "SONAR_TOKEN=your_sonar_token" >> .github/act-secrets.env
#     echo "SONAR_PROJECT_KEY=${var.owner}_${var.project_name}" >> .github/act-secrets.env
#     echo "SONAR_ORGANIZATION=${var.owner}" >> .github/act-secrets.env
#     echo "" >> .github/act-secrets.env
#     echo "# Snyk Token - Get from your Snyk account" >> .github/act-secrets.env
#     echo "SNYK_TOKEN=your_snyk_token" >> .github/act-secrets.env
#     echo "" >> .github/act-secrets.env
#     echo "# AWS Configuration" >> .github/act-secrets.env
#     echo "IAM_ROLE=$(terraform output -raw github_actions_role_arn)" >> .github/act-secrets.env
#     echo "AWS_REGION=$(terraform output -raw aws_region)" >> .github/act-secrets.env
#     echo "" >> .github/act-secrets.env
#     echo "# ECR Repository" >> .github/act-secrets.env
#     echo "ECR_REPO=$(terraform output -raw ecr_repository_name)" >> .github/act-secrets.env
#     echo "ECR_REGISTRY=$(terraform output -raw ecr_repository_url | cut -d'/' -f1)" >> .github/act-secrets.env
#     echo "" >> .github/act-secrets.env
#     echo "# S3 Bucket for Reports" >> .github/act-secrets.env
#     echo "REPORTS_BUCKET=$(terraform output -raw reports_bucket_name)" >> .github/act-secrets.env
#     echo "" >> .github/act-secrets.env
#     echo "# Slack Webhook" >> .github/act-secrets.env
#     echo "SLACK_WEBHOOK_URL=https://hooks.slack.com/services/your-webhook-path" >> .github/act-secrets.env
#     echo "" >> .github/act-secrets.env
#     echo "# ECS Configuration (for CD workflow)" >> .github/act-secrets.env
#     echo "ECS_CLUSTER=$(terraform output -raw ecs_cluster_name)" >> .github/act-secrets.env
#     echo "ECS_SERVICE=$(terraform output -raw ecs_service_name)" >> .github/act-secrets.env
#     echo "ECS_FAMILY=$(terraform output -raw ecs_task_family)" >> .github/act-secrets.env
#   EOT
# }