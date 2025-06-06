# -----------------------------------------
# General Variables
# -----------------------------------------
# Primary Region
variable "primary_region" {
  description = "AWS region to deploy resources"
  type        = string
}

# Secondary Region
variable "sec_region" {
  description = "AWS region to deploy resources"
  type        = string
}

# Project Name
variable "project_name" {
  description = "Project name"
  type        = string
}

# Owner
variable "owner" {
  description = "Owner information"
  type        = string
}

# Environment
variable "environment" {
  description = "Environment name"
  type        = string
}

# --------------------------------------------------------------------
# Variables for Workspace Configuration
# --------------------------------------------------------------------
# Workspace Config
variable "workspace_config" {
  description = "Configuration values for each workspace"
  type = map(object({
    flow_logs_retention_days = number
    log_retention_days       = number
    api_latency_threshold    = number
    cpu_threshold            = number
    task_cpu                 = number
    task_memory              = number
    instance_count           = number
    instance_type            = string
    backup_retention_days    = number
    ecs_min_capacity         = number
    ecs_max_capacity         = number
    memory_target_value      = number
    memory_threshold         = number
    cpu_target_value         = number
    night_min_capacity       = number
    night_max_capacity       = number

    waf_rule_thresholds = optional(object({
      request_limit = optional(number, 2000)
      ip_rate_limit = optional(number, 2000)
    }))
  }))
}

# --------------------------------------------------------------------
# Variables for Networking module
# --------------------------------------------------------------------

# VPC CIDR Block
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

# Availability Zones
variable "availability_zones_count" {
  description = "Number of AZs to use"
  type        = number
}

# --------------------------------------------------------------------
# Variables for Security module
# --------------------------------------------------------------------
# WAF Scope
variable "waf_scope" {
  description = "Whether the WAF is for REGIONAL (ALB) or CLOUDFRONT"
  type        = string
  default     = "REGIONAL"
}

# WAF Default Action
variable "waf_default_action" {
  description = "Default action for WAF (allow or block)"
  type        = string
  default     = "ALLOW"
}

# Container Port
variable "container_port" {
  description = "Port that the container listens on"
  type        = number
}

# --------------------------------------------------------------------
# Variables for Load Balancer module
# --------------------------------------------------------------------

# ALB Domain Name
variable "wildcard_domain_name" {
  description = "The wildcard domain name"
  type        = string
}

# ALB HTTPS Listener Port
variable "alb_https_listener_port" {
  description = "HTTPS port for ALB listener"
  type        = number
}

# -----------------------------------------------------------------------
# Variables for Compute module
# -----------------------------------------------------------------------
# App Version
variable "app_version" {
  description = "The version of the application"
  type        = string
}

# Container User
variable "container_user" {
  description = "The user to run the container as (for security)"
  type        = string
}

# -----------------------------------------------------------------------
# Variables for Monitoring module
# -----------------------------------------------------------------------

# Alert Email
variable "alert_email_address" {
  description = "Email address to receive alerts"
  type        = string
}

# Security Alert Email
variable "security_alert_email_address" {
  description = "Email address to receive security alerts"
}

# ------------------------------------------------------------------------
# Variables for DNS Module
# ------------------------------------------------------------------------

# Primary Domain Name
variable "primary_domain_name" {
  description = "The primary domain name"
  type        = string
}

# Portfolio Domain Name
variable "portfolio_domain_name" {
  description = "The portfolio domain name"
  type        = string
}

# ------------------------------------------------------------------------
# Variables for GitHub OIDC Module
# ------------------------------------------------------------------------

# GitHub Owner
variable "github_owner" {
  description = "GitHub organization or user name"
  type        = string
}

# Infrastructure Repository Name
variable "infra_repo" {
  description = "Name of the infrastructure repository"
  type        = string
}

# Application Repository Name
variable "app_repo" {
  description = "Name of the application repository"
  type        = string
}

# GitHub Organisation
variable "github_org" {
  description = "GitHub organization name"
  type        = string
}