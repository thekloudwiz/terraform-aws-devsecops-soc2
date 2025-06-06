# ECS Task Execution Role Policy
resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "${local.name_prefix}-ecs-task-execution-role"
  assume_role_policy = file("${path.root}/policies/ecs-task-assume-role-policy.json")

  tags = local.common_tags
}

# ECS Task Execution Role Policy
resource "aws_iam_role_policy" "ecs_task_execution_role_policy" {
  name   = "${local.name_prefix}-ecs-task-execution-role-policy"
  role   = aws_iam_role.ecs_task_execution_role.id
  policy = file("${path.root}/policies/ecs-task-execution-role-policy.json")
}

# Add ECR pull permissions
resource "aws_iam_role_policy" "ecr_pull_policy" {
  name   = "${local.name_prefix}-ecr-pull-policy"
  role   = aws_iam_role.ecs_execution_role.id
  policy = file("${path.root}/policies/ecr-pull-policy.json")
}

# Create ECS Task Role
resource "aws_iam_role" "ecs_task_role" {
  name = "${local.name_prefix}-task-role"

  assume_role_policy = file("${path.root}/policies/ecs-assume-role-policy.json")
}

# Create ECS Task Execution Role
resource "aws_iam_role" "ecs_execution_role" {
  name = "${local.name_prefix}-execution-role"

  assume_role_policy = file("${path.root}/policies/ecs-assume-role-policy.json")
}

# Add SSM access for secrets if needed
resource "aws_iam_role_policy_attachment" "ecs_task_ssm" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = data.aws_iam_policy.ssm_read_only.arn
}

# Add CloudWatch Logs policy to Task Role
resource "aws_iam_role_policy_attachment" "ecs_task_cloudwatch" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = data.aws_iam_policy.ecs_task_execution_policy.arn
}

# Add ECS Task Execution Role policy
resource "aws_iam_role_policy_attachment" "ecs_task_execution" {
  role = aws_iam_role.ecs_execution_role.name

  policy_arn = data.aws_iam_policy.ecs_task_execution_policy.arn
}

resource "aws_iam_role" "backup_role" {
  name               = "${local.name_prefix}-backup-role"
  assume_role_policy = file("${path.root}/policies/backup-assume-role-policy.json")
}

resource "aws_iam_role_policy_attachment" "backup_policy_attachment" {
  role       = aws_iam_role.backup_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
}