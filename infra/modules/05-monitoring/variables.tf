variable "owner" {
  description = "Owner of the project"
  type        = string
}

variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "primary_region" {
  description = "AWS Region"
  type        = string
}

variable "alert_email_address" {
  description = "Email address to receive alerts"
  type        = string
}

variable "security_alert_email_address" {
  description = "Email address to receive security alerts"

}

variable "alb_arn_suffix" {
  description = "ARN suffix of the ALB"
  type        = string
}

# Workspace Config
variable "workspace_config" {
  description = "Configuration values for each workspace"
  type = map(object({
    flow_logs_retention_days = number
    log_retention_days       = number
    api_latency_threshold    = number
    cpu_threshold            = number
    memory_threshold         = number
  }))
}

# variable "flow_logs_retention_days" {
#   description = "Number of days to retain VPC Flow Logs"
#   type        = number
# }

# variable "api_latency_threshold" {
#   description = "Threshold for API latency"
#   type        = number
#   default     = 1
# }

# variable "log_retention_days" {
#   description = "Number of days to retain CloudWatch logs"
#   type        = number
#   default     = 30
# }

# variable "cpu_threshold" {
#   description = "CPU utilization threshold for alarm"
#   type        = number
#   default     = 80
# }