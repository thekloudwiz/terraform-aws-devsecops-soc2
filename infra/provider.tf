provider "aws" {
  region = var.primary_region

  # default_tags {
  #   tags = local.common_tags
  # }
}

provider "aws" {
  alias  = "secondary"
  region = var.sec_region # Frankfurt as backup region

  # default_tags {
  #   tags = local.common_tags
  # }
}

# # terraform backend
# terraform {
#   backend "s3" {
#     bucket         = "devsecops-tfstate-01032025"
#     key            = "infra/terraform.tfstate"
#     region         = "eu-west-1"
#     encrypt        = true
#     use_lockfile   = true
#   }
# }