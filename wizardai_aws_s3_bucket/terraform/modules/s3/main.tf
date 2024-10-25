resource "aws_s3_bucket" "this" {
  bucket = "${local.bucket_prefix}-${var.name}-${var.environment}"

  # Allow the bucket to be destroyed or not, based on input
  force_destroy = var.force_destroy
}

# Server-side encryption configuration
resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = var.encryption_type == "SSE-KMS" ? "aws:kms" : "AES256"
      kms_master_key_id = var.encryption_type == "SSE-KMS" ? var.kms_key_id : null
    }
  }
}

# Conditionally create the versioning resource only if versioning is explicitly enabled or suspended
resource "aws_s3_bucket_versioning" "this" {
  count = var.versioning != null ? 1 : 0

  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = var.versioning == true ? "Enabled" : "Suspended"
  }
}

# Access logging configuration (ensure the logging bucket exists)
resource "aws_s3_bucket_logging" "this" {
  bucket        = aws_s3_bucket.this.id
  target_bucket = "wizardai-logs"
  target_prefix = "${var.name}/"
}

# Ensure encryption in transit (via bucket policy)
resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action    = "s3:*",
        Effect    = "Deny",
        Resource  = "${aws_s3_bucket.this.arn}/*",
        Condition = {
          Bool = {
            "aws:SecureTransport" = "false"
          }
        },
        Principal = "*"
      }
    ]
  })
}

# Public access block configuration (optional based on enable_public_access_block)
resource "aws_s3_bucket_public_access_block" "this" {
  count = var.public_access_block ? 1 : 0

  bucket = aws_s3_bucket.this.id

  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls  = true
  restrict_public_buckets = true
}
