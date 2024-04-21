
# ---------------------------------------------------------------------
# Content Delivery Network (CDN)
# ---------------------------------------------------------------------

# Create CDN using AWS CloudFront 

locals {
  origin = "site.${local.domain}"
}

resource "aws_cloudfront_origin_access_identity" "site" {
  comment = "access-identity-ebb-site.s3.amazonaws.com"
}


resource "aws_cloudfront_distribution" "this" {

  # Origin
  # Define the origin for the CDN - the S3 bucket containing the 
  # static files files for our web application. 

  origin {
    domain_name = aws_s3_bucket.dist.bucket_regional_domain_name
    origin_id   = "site.${local.domain}"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.site.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = local.origin
  default_root_object = "index.html"

  aliases = ["site.${local.domain}"]


  # Default Behavior

  default_cache_behavior {

    # Compression (gzip)
    compress = true

    # Allow all HTTP methods. Cache read-only methods. 
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.origin

    forwarded_values {
      query_string = true

      cookies {
        forward = "none"
      }
    }

    # Redirect HTTP traffic to HTTPS.
    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  # Pricing Class
  # Note: "PriceClass_All" is required for Australian locations. 

  price_class = "PriceClass_All"


  # Geographical Restrictions 

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  # Secure Transport
  # Define certificate used for encryption over the wire. 

  viewer_certificate {
    acm_certificate_arn      = data.aws_acm_certificate.cert.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  # Custom Error Response
  # Note: For Single Page Applications (SPA), we need to replace 403 
  # Forbidden errors with 200 OK and redirect to the index.html page. 
  # This allows the SPA to handle the routing properly. 

  custom_error_response {
    error_code         = 403
    response_code      = 200
    response_page_path = "/index.html"
  }

  tags = local.tags
}


data "aws_acm_certificate" "cert" {
  domain    = local.origin
  statuses  = ["ISSUED"]
  key_types = ["RSA_2048"]

  provider = aws.virginia
}
