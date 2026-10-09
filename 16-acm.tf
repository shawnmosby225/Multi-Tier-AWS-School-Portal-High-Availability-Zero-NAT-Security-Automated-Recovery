resource "aws_acm_certificate" "portal_certificate" {
  domain_name       = "portal.lewsclassdomain.com"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "school-portal-certificate"
  }
}