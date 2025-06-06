# Local variable for naming conventions
locals {
    name_prefix = "${var.owner}-${terraform.workspace}-${var.project_name}"

    bucket_name = "${local.name_prefix}-${var.bucket_name}-${var.pr_suffix}"
    replica_bucket_name = "${local.name_prefix}-${var.replica_bucket}-${var.sr_suffix }"

    common_tags = {
        Environment = terraform.workspace
        Managed_by  = "terraform"
        Owner       = var.owner
        Project     = var.project_name
    }
}