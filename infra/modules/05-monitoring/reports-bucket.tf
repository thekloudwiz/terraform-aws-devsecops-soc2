# Create an S3 bucket for reports
resource "aws_s3_bucket" "reports_bucket" {
    bucket        = "${local.name_prefix}-reports-bucket"
    force_destroy = true

    tags = merge(local.common_tags, {
        Name = "${local.name_prefix}-reports-bucket"
    })
    }