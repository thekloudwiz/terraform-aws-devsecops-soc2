# -----------------------------------------
# General Variables
# -----------------------------------------
project_name   = "tf-aws-soc2"
owner          = "thekloudwiz"
environment    = "dev"
primary_region = "eu-west-1"
sec_region     = "eu-central-1"

# --------------------------------------------------------------------
# Variables for Workspace Configuration
# --------------------------------------------------------------------
workspace_config = {
  
  prod = {
    instance_count           = 2
    instance_type            = "t3.medium"
    log_retention_days       = 30
    backup_retention_days    = 30
    ecs_min_capacity         = 2
    ecs_max_capacity         = 5
    task_cpu                 = 1024
    task_memory              = 2048
    memory_target_value      = 70
    cpu_target_value         = 70
    flow_logs_retention_days = 7
    memory_threshold         = 70
    night_min_capacity       = 1
    night_max_capacity       = 2
    api_latency_threshold    = 1
    cpu_threshold            = 70

    waf_rule_thresholds = {
      request_limit = 2000
      ip_rate_limit = 2000
    }
  }
}

# --------------------------------------------------------------------
# Variables for Networking module
# --------------------------------------------------------------------
vpc_cidr                 = "10.0.0.0/16"
availability_zones_count = 2 # Number of AZs to use

# --------------------------------------------------------------------
# Variables for Security module
# --------------------------------------------------------------------
waf_scope          = "REGIONAL"
waf_default_action = "ALLOW"
container_port     = 3000

# --------------------------------------------------------------------
# Variables for Load Balancer module
# --------------------------------------------------------------------
wildcard_domain_name         = "*.thekloudwiz.com"
portfolio_domain_name        = "portfolio.thekloudwiz.com"
alb_https_listener_port      = 443
primary_domain_name          = "thekloudwiz.com"
alert_email_address          = "thekloudwiz+dev@gmail.com"
security_alert_email_address = "thekloudwiz+alerts@gmail.com"

# --------------------------------------------------------------------
# Variables for Compute module
# --------------------------------------------------------------------
app_version    = "1.0.0"
container_user = "1000:1000"

# --------------------------------------------------------------------
# Variables for GITHUB OIDC
# --------------------------------------------------------------------
github_org  = "thekloudwiz"
github_owner = "thekloudwiz"
infra_repo = "terraform-aws-devsecops-soc2"
app_repo = "terraform-aws-devsecops-soc2"