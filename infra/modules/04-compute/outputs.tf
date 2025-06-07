# ECR Repository outputs
output "ecr_repository_url" {
  description = "URL of the ECR repository"
  value       = aws_ecr_repository.ecr_repo.repository_url
}

output "ecr_repository_name" {
  description = "Name of the ECR repository"
  value       = aws_ecr_repository.ecr_repo.name
}

# ECS outputs
output "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  value       = aws_ecs_cluster.ecs_cluster.name
}

output "container_insights_enabled" {
  description = "Whether Container Insights is enabled for the ECS cluster"
  value       = contains(aws_ecs_cluster.ecs_cluster.setting[*].name, "containerInsights") ? true : false
}

output "kms_key_id" {
  description = "ID of the KMS key used for encryption"
  value       = aws_kms_key.ecr_key.id
}

output "backup_plan_id" {
  description = "ID of the AWS Backup plan"
  value       = aws_backup_plan.backup_plan.id
}

output "ecs_service_name" {
  description = "Name of the ECS service"
  value       = aws_ecs_service.ecs_service.name
}

output "ecs_task_family" {
  description = "Family name of the ECS task definition"
  value       = aws_ecs_task_definition.task.family
}