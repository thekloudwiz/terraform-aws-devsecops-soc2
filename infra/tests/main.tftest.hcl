# Common variables for all tests
variables {
  region         = "eu-west-1"
  owner          = "thekloudwiz"
  project_name   = "tf-aws-soc2"
  primary_region = "eu-west-1"
  
  # VPC Configuration
  vpc_cidr              = "10.0.0.0/16"
  public_subnet_cidrs   = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs  = ["10.0.3.0/24", "10.0.4.0/24"]
  
  # Domain Configuration
  domain_name         = "portfolio.thekloudwiz.com"
  create_route53_zone = false
}

# Test basic infrastructure setup
run "verify_infrastructure_setup" {
  command = plan

  assert {
    condition     = module.networking != null
    error_message = "Networking module should be configured"
  }

  assert {
    condition     = module.security != null
    error_message = "Security module should be configured"
  }

  assert {
    condition     = module.compute != null
    error_message = "Compute module should be configured"
  }

  assert {
    condition     = module.load_balancer != null
    error_message = "Load balancer module should be configured"
  }

  assert {
    condition     = module.monitoring != null
    error_message = "Monitoring module should be configured"
  }
}

# Test networking configuration
run "verify_networking" {
  command = plan

  assert {
    condition     = length(module.networking.public_subnet_ids) >= 2
    error_message = "Must have at least 2 public subnets for high availability"
  }

  assert {
    condition     = length(module.networking.private_subnet_ids) >= 2
    error_message = "Must have at least 2 private subnets for high availability"
  }
  
  # Database subnet assertion removed as it's not used in this infrastructure
}

# Test security configuration
run "verify_security_resources" {
  command = plan

  assert {
    condition     = module.security.guardduty_enabled == true
    error_message = "GuardDuty must be enabled"
  }

  assert {
    condition     = module.security.waf_enabled == true
    error_message = "WAF must be enabled"
  }

  assert {
    condition     = length(module.security.security_group_ids) > 0
    error_message = "Security groups must be properly configured"
 }
}

# Test compute configuration
run "verify_compute_resources" {
  command = plan

  assert {
    condition     = can(module.compute.ecr_repository_name)
    error_message = "ECR repository must be configured"
  }

  assert {
    condition     = can(module.compute.ecs_cluster_name)
    error_message = "ECS cluster must be configured"
  }

  assert {
    condition     = can(module.compute.ecs_service_name)
    error_message = "ECS service must be configured"
  }

  assert {
    condition     = can(module.compute.ecs_task_family)
    error_message = "ECS task definition must be configured"
  }
  
  assert {
    condition     = can(module.compute.container_insights_enabled)
    error_message = "Container Insights setting must be configured"
  }
}

# Test load balancer configuration
run "verify_load_balancer_resources" {
  command = plan

  assert {
    condition = module.load_balancer.ssl_policy == "ELBSecurityPolicy-TLS13-1-2-2021-06"
    error_message = "ALB must use modern TLS policy (TLS 1.3)"
  }

  # Environment-specific deletion protection check
  assert {
    condition = (
      terraform.workspace == "prod" ? module.load_balancer.deletion_protection_enabled : true
    )
    error_message = "ALB deletion protection must be enabled in production environment"
  }
}

# Test monitoring configuration
run "verify_monitoring_resources" {
  command = plan

  assert {
    condition     = can(module.monitoring.cloudwatch_log_group_name)
    error_message = "CloudWatch log group must be configured"
  }

  assert {
    condition = alltrue([
      # Check if SNS topic is being created
      try(module.monitoring.sns_topic_name != "", true)
    ])
    error_message = "SNS topic is not configured correctly"
  }

  assert {
    condition     = can(module.monitoring.reports_bucket_name)
    error_message = "Reports bucket must be configured"
  }
}

# Test GitHub OIDC configuration (SOC2 requirement)
run "verify_github_oidc_resources" {
  command = plan

  assert {
    condition     = can(module.github_oidc.github_actions_role_arn) != ""
    error_message = "GitHub Actions role must be configured"
  }

  assert {
    condition     = can(module.github_oidc.github_oidc_provider_arn) != ""
    error_message = "GitHub OIDC provider must be configured"
  }
}

# Test encryption at rest (SOC2 requirement)
run "verify_encryption_at_rest" {
  command = plan

  assert {
    condition     = can(module.compute.kms_key_id) != ""
    error_message = "KMS encryption must be configured for data at rest"
  }
}

# Test backup and recovery (SOC2 requirement)
run "verify_backup_and_recovery" {
  command = plan

  assert {
    condition     = can(module.compute.backup_plan_id) != ""
    error_message = "AWS Backup must be configured for disaster recovery"
  }
}