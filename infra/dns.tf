
# Get the parent domain (hosted zone) for the current account. 

data "aws_route53_zone" "this" {
  name         = local.domain
  private_zone = false
}

# ---------------------------------------------------------------------
# Records
# ---------------------------------------------------------------------

# Create alias record for for the web application. This record will 
# be used to route to the cloudfront distribution. 

resource "aws_route53_record" "this" {
  zone_id = data.aws_route53_zone.this.zone_id
  name    = "site.${local.domain}."
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.this.domain_name
    zone_id                = "Z2FDTNDATAQYW2" # cloudfront
    evaluate_target_health = false
  }

  depends_on = [
    aws_cloudfront_distribution.this
  ]
}
