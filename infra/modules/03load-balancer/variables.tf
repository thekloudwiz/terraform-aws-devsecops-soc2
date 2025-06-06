# Project Owner
variable "owner" {
  description = "Owner of the project"
  type        = string
}

# Project Name
variable "project_name" {
  description = "Name of the project"
  type        = string
}

# ALB Domain Name
variable "wildcard_domain_name" {
  description = "The wildcard domain name"
  type        = string
}

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

# ALB HTTPS Listener Port
variable "alb_https_listener_port" {
  description = "HTTPS port for ALB listener"
  type        = number
}

# Container Port
variable "container_port" {
  description = "Port on which the container is listening"
  type        = number
}

# # SSL Certificate ARN
# variable "alb_certificate_arn" {
#   description = "ARN of the SSL certificate for ALB"
#   type        = string
# }

# # WAF ACL ID
# variable "waf_acl_id" {
#   description = "ID of the WAF ACL to associate with the ALB"
#   type        = string
# }

# # IAM Certificate Name
# variable "iam_cert_name" {
#   description = "The IAM certificate name"
#   type        = string
# }

# # ALB Name
# variable "alb_name" {
#   description = "Name of the ALB"
#   type        = string
# }

# variable "waf_scope" {
#   description = "Scope of the WAF ACL"
#   type        = string
# }

# variable "subnet_ids" {
#   description = "List of subnet IDs"
#   type        = list(string)
# }

# variable "alb_security_group_id" {
#   description = "ID of the ALB security group"
#   type        = string
# }

