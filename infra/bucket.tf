
# ---------------------------------------------------------------------
# Bucket (Web Content Repository) 
# ---------------------------------------------------------------------

# Create a bucket for storing the static files generated after 
# building the web application.  

resource "aws_s3_bucket" "dist" {
  bucket = "ebb-site"

  tags = local.tags
}

# Setup website configuration.

resource "aws_s3_bucket_website_configuration" "dist" {
  bucket = aws_s3_bucket.dist.id

  index_document {
    suffix = "index.html"
  }
}

# Use server-side encryption to ensure the application contents 
# is encrypted at rest.  

resource "aws_s3_bucket_server_side_encryption_configuration" "dist" {
  bucket = aws_s3_bucket.dist.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Ensure the bucket and its contents are NOT publicly accessible. 

resource "aws_s3_bucket_public_access_block" "dist" {
  bucket = aws_s3_bucket.dist.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


# ---------------------------------------------------------------------
# Bucket Policy
# ---------------------------------------------------------------------

# Create bucket policy to allow the CDN (AWS CloudFront Distribution)
# to access the content of the bucket (static files).    

data "aws_iam_policy_document" "dist" {
  version = "2012-10-17"

  statement {
    effect = "Allow"

    actions = ["s3:GetObject"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.this.iam_arn]
    }

    resources = [
      aws_s3_bucket.dist.arn,
      "${aws_s3_bucket.dist.arn}/*"
    ]
  }
}

resource "aws_s3_bucket_policy" "dist" {
  bucket = aws_s3_bucket.dist.id
  policy = data.aws_iam_policy_document.dist.json
}

