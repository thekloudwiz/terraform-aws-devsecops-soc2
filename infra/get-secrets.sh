#!/bin/bash
# Script to extract all GitHub Actions secrets from Terraform outputs

# Set the environment
ENV=${1:-dev}

# Change to the infrastructure directory
cd "$(dirname "$0")"

# Select the correct workspace
terraform workspace select $ENV

# Create the secrets file
SECRETS_FILE="../.github/act-secrets.env"
mkdir -p "../.github"

echo "# Generated GitHub Actions secrets for Act - $(date)" > $SECRETS_FILE
echo "# Environment: $ENV" >> $SECRETS_FILE
echo "" >> $SECRETS_FILE

# GitHub Token (manual entry required)
echo "# GitHub Token - Create a Personal Access Token at https://github.com/settings/tokens" >> $SECRETS_FILE
echo "GITHUB_TOKEN=ghp_your_github_personal_access_token" >> $SECRETS_FILE
echo "" >> $SECRETS_FILE

# SonarCloud Tokens (manual entry required)
echo "# SonarCloud Tokens - Get these from your SonarCloud account" >> $SECRETS_FILE
echo "SONAR_TOKEN=your_sonar_token" >> $SECRETS_FILE
echo "SONAR_PROJECT_KEY=$(terraform output -raw github_repository | tr '/' '_')" >> $SECRETS_FILE
echo "SONAR_ORGANIZATION=$(terraform output -raw github_repository | cut -d'/' -f1)" >> $SECRETS_FILE
echo "" >> $SECRETS_FILE

# Snyk Token (manual entry required)
echo "# Snyk Token - Get from your Snyk account" >> $SECRETS_FILE
echo "SNYK_TOKEN=your_snyk_token" >> $SECRETS_FILE
echo "" >> $SECRETS_FILE

# AWS Configuration
echo "# AWS Configuration" >> $SECRETS_FILE
echo "IAM_ROLE=$(terraform output -raw github_actions_role_arn)" >> $SECRETS_FILE
echo "AWS_REGION=$(terraform output -raw aws_region)" >> $SECRETS_FILE
echo "" >> $SECRETS_FILE

# ECR Repository
echo "# ECR Repository" >> $SECRETS_FILE
echo "ECR_REPO=$(terraform output -raw ecr_repository_name)" >> $SECRETS_FILE
echo "ECR_REGISTRY=$(terraform output -raw ecr_repository_url | cut -d'/' -f1)" >> $SECRETS_FILE
echo "" >> $SECRETS_FILE

# S3 Bucket for Reports
echo "# S3 Bucket for Reports" >> $SECRETS_FILE
echo "REPORTS_BUCKET=$(terraform output -raw reports_bucket_name)" >> $SECRETS_FILE
echo "" >> $SECRETS_FILE

# Slack Webhook (manual entry required)
echo "# Slack Webhook" >> $SECRETS_FILE
echo "SLACK_WEBHOOK_URL=https://hooks.slack.com/services/your-webhook-path" >> $SECRETS_FILE
echo "" >> $SECRETS_FILE

# ECS Configuration
echo "# ECS Configuration (for CD workflow)" >> $SECRETS_FILE
echo "ECS_CLUSTER=$(terraform output -raw ecs_cluster_name)" >> $SECRETS_FILE
echo "ECS_SERVICE=$(terraform output -raw ecs_service_name)" >> $SECRETS_FILE
echo "ECS_FAMILY=$(terraform output -raw ecs_task_family)" >> $SECRETS_FILE

echo "Secrets file created at $SECRETS_FILE"
echo "Please update the manual entries (GitHub token, SonarCloud token, Snyk token, Slack webhook)"