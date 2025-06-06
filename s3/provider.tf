# Get current AWS account ID
data "aws_caller_identity" "current" {} 

provider "aws" {
  region = var.primary_region

  default_tags {
    tags = local.common_tags
  }
}

provider "aws" {
  alias  = "secondary"
  region = var.sec_region # Frankfurt as backup region

  default_tags {
    tags = local.common_tags
  }
}