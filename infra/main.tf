# Create Networking Environment
module "networking" {
  source                   = "./modules/01networking"
  owner                    = var.owner
  project_name             = var.project_name
  environment              = terraform.workspace
  vpc_cidr                 = var.vpc_cidr
  availability_zones_count = var.availability_zones_count
}

# Create Security Environment
module "security" {
  source             = "./modules/02security"
  project_name       = var.project_name
  owner              = var.owner
  workspace_config   = var.workspace_config
  waf_scope          = var.waf_scope
  waf_default_action = var.waf_default_action
  container_port     = var.container_port

  depends_on = [module.networking]
}

# Create Load Balancer
module "load_balancer" {
  source                  = "./modules/03load-balancer"
  project_name            = var.project_name
  owner                   = var.owner
  container_port          = var.container_port
  alb_https_listener_port = var.alb_https_listener_port
  primary_domain_name     = var.primary_domain_name
  portfolio_domain_name   = var.portfolio_domain_name
  wildcard_domain_name    = var.wildcard_domain_name

  depends_on = [module.security]
}

# Create Compute Environment
module "compute" {
  source           = "./modules/04-compute"
  workspace_config = var.workspace_config
  project_name     = var.project_name
  owner            = var.owner
  primary_region   = var.primary_region
  container_port   = var.container_port
  container_user   = var.container_user
  app_version      = var.app_version

  depends_on = [module.load_balancer]
}

# Create Monitoring Environment
module "monitoring" {
  source                       = "./modules/05-monitoring"
  primary_region               = var.primary_region
  project_name                 = var.project_name
  owner                        = var.owner
  alb_arn_suffix               = module.load_balancer.alb_arn_suffix
  alert_email_address          = var.alert_email_address
  security_alert_email_address = var.security_alert_email_address
  workspace_config             = var.workspace_config

  depends_on = [module.load_balancer, module.security, module.networking, module.compute]
}

# Create DNS Module
module "dns" {
  source                = "./modules/07-dns"
  owner                 = var.owner
  project_name          = var.project_name
  primary_domain_name   = var.primary_domain_name
  portfolio_domain_name = var.portfolio_domain_name

  depends_on = [module.load_balancer]
}

# Create GitHub OIDC Module
module "github_oidc" {
  source         = "./modules/08-iam-github"
  prefix         = "${var.owner}-${var.project_name}-${terraform.workspace}"
  github_owner   = var.github_owner
  github_org = var.github_org
  infra_repo = var.infra_repo
  app_repo  = var.app_repo
  tags           = {
    Owner       = var.owner
    Project     = var.project_name
    Environment = terraform.workspace
    Terraform   = "true"
  }
}

# # # Create CloudWatch Access Environment
# # module "cloudwatch_access" {
# #   source            = "./modules/06cloudwatch-access"
# #   aws_region        = var.aws_region
# #   environment       = terraform.workspace
# #   project_name      = var.project_name
# #   owner            = var.owner
# #   enable_sso       = var.enable_sso
# #   sso_instance_arn = var.sso_instance_arn
# #   team_member_names = var.team_member_names
# #   depends_on       = [module.compute]
# # }