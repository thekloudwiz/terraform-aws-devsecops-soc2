variable "prefix" {
  description = "Prefix to be used for resource naming"
  type        = string
}

# GitHub Organisation
variable "github_org" {
  description = "GitHub organization name"
  type        = string
}

variable "github_owner" {
  description = "GitHub organization or user name"
  type        = string
}

variable "infra_repo" {
  description = "Name of the infrastructure repository"
  type        = string
}

variable "app_repo" {
  description = "Name of the application repository"
  type        = string
}

variable "tags" {
  description = "Tags to be applied to resources"
  type        = map(string)
  default     = {}
}