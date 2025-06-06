# PowerShell script to extract all GitHub Actions secrets from Terraform outputs

# Set the environment
param(
    [string]$Env = "dev"
)

# Change to the infrastructure directory
Set-Location -Path $PSScriptRoot

# Select the correct workspace
terraform workspace select $Env

# Create the secrets file
$SecretsFile = "..\\.github\\act-secrets.env"
New-Item -Path "..\\.github" -ItemType Directory -Force | Out-Null

# Start writing to the file
"# Generated GitHub Actions secrets for Act - $(Get-Date)" | Out-File -FilePath $SecretsFile
"# Environment: $Env" | Out-File -FilePath $SecretsFile -Append
"" | Out-File -FilePath $SecretsFile -Append

# GitHub Token (manual entry required)
"# GitHub Token - Create a Personal Access Token at https://github.com/settings/tokens" | Out-File -FilePath $SecretsFile -Append
"GITHUB_TOKEN=ghp_your_github_personal_access_token" | Out-File -FilePath $SecretsFile -Append
"" | Out-File -FilePath $SecretsFile -Append

# SonarCloud Tokens (manual entry required)
"# SonarCloud Tokens - Get these from your SonarCloud account" | Out-File -FilePath $SecretsFile -Append
"SONAR_TOKEN=your_sonar_token" | Out-File -FilePath $SecretsFile -Append
$GithubRepo = terraform output -raw github_repository
$SonarProjectKey = $GithubRepo -replace "/", "_"
$SonarOrg = $GithubRepo.Split("/")[0]
"SONAR_PROJECT_KEY=$SonarProjectKey" | Out-File -FilePath $SecretsFile -Append
"SONAR_ORGANIZATION=$SonarOrg" | Out-File -FilePath $SecretsFile -Append
"" | Out-File -FilePath $SecretsFile -Append

# Snyk Token (manual entry required)
"# Snyk Token - Get from your Snyk account" | Out-File -FilePath $SecretsFile -Append
"SNYK_TOKEN=your_snyk_token" | Out-File -FilePath $SecretsFile -Append
"" | Out-File -FilePath $SecretsFile -Append

# AWS Configuration
"# AWS Configuration" | Out-File -FilePath $SecretsFile -Append
"IAM_ROLE=$(terraform output -raw github_actions_role_arn)" | Out-File -FilePath $SecretsFile -Append
"AWS_REGION=$(terraform output -raw aws_region)" | Out-File -FilePath $SecretsFile -Append
"" | Out-File -FilePath $SecretsFile -Append

# ECR Repository
"# ECR Repository" | Out-File -FilePath $SecretsFile -Append
"ECR_REPO=$(terraform output -raw ecr_repository_name)" | Out-File -FilePath $SecretsFile -Append
$EcrUrl = terraform output -raw ecr_repository_url
$EcrRegistry = $EcrUrl.Split("/")[0]
"ECR_REGISTRY=$EcrRegistry" | Out-File -FilePath $SecretsFile -Append
"" | Out-File -FilePath $SecretsFile -Append

# S3 Bucket for Reports
"# S3 Bucket for Reports" | Out-File -FilePath $SecretsFile -Append
"REPORTS_BUCKET=$(terraform output -raw reports_bucket_name)" | Out-File -FilePath $SecretsFile -Append
"" | Out-File -FilePath $SecretsFile -Append

# Slack Webhook (manual entry required)
"# Slack Webhook" | Out-File -FilePath $SecretsFile -Append
"SLACK_WEBHOOK_URL=https://hooks.slack.com/services/your-webhook-path" | Out-File -FilePath $SecretsFile -Append
"" | Out-File -FilePath $SecretsFile -Append

# ECS Configuration
"# ECS Configuration (for CD workflow)" | Out-File -FilePath $SecretsFile -Append
"ECS_CLUSTER=$(terraform output -raw ecs_cluster_name)" | Out-File -FilePath $SecretsFile -Append
"ECS_SERVICE=$(terraform output -raw ecs_service_name)" | Out-File -FilePath $SecretsFile -Append
"ECS_FAMILY=$(terraform output -raw ecs_task_family)" | Out-File -FilePath $SecretsFile -Append

Write-Host "Secrets file created at $SecretsFile"
Write-Host "Please update the manual entries (GitHub token, SonarCloud token, Snyk token, Slack webhook)"