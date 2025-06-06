# Variables for storage module

# Primary Region
variable "primary_region" {
    description = "AWS region to deploy resources"
    type        = string
}

# Primary Region Suffix
variable "pr_suffix" {
    description = "AWS region to deploy resources"
    type        = string
}

# Secondary Region
variable "sec_region" {
    description = "AWS region to deploy resources"
    type        = string
}

# Secondary Region Suffix
variable "sr_suffix" {
    description = "AWS region to deploy resources"
    type        = string
}

# Owner
variable "owner" {
    description = "Owner of the resources"
    type        = string
}

# Project Name
variable "project_name" {
    description = "Name of the project"
    type        = string
}

# S3 Bucket Name
variable "bucket_name" {
    description = "Name of the S3 bucket"
    type        = string
}

# S3 Replica Bucket Name
variable "replica_bucket" {
    description = "Name of the S3 bucket"
    type        = string
}