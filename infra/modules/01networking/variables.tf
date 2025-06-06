
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