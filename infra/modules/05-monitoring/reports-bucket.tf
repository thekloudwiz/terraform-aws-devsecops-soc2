# Create an S3 bucket for reports
resource "aws_s3_bucket" "reports_bucket" {
    bucket        = "${local.name_prefix}-reports-bucket"
    force_destroy = true

    tags = merge(local.common_tags, {
        Name = "${local.name_prefix}-reports-bucket"
    })
    }

# Enable versioning on the bucket
resource "aws_s3_bucket_versioning" "reports_bucket_versioning" {
bucket = aws_s3_bucket.reports_bucket.id
versioning_configuration {
    status = "Enabled"
}
}

# Enable server-side encryption on the bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "reports_bucket_encryption" {
bucket = aws_s3_bucket.reports_bucket.id
rule {
    apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
    }
}
}

# Enable logging on the bucket
resource "aws_s3_bucket_logging" "reports_bucket_logging" {
bucket = aws_s3_bucket.reports_bucket.id
target_bucket = aws_s3_bucket.reports_bucket.id
target_prefix = "logs/"
}

# Enable event notification on the bucket
resource "aws_s3_bucket_notification" "reports_bucket_notification" {
bucket = aws_s3_bucket.reports_bucket.id
eventbridge = true
}