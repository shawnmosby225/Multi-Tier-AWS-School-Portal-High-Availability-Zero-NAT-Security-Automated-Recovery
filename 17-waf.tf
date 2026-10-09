resource "aws_wafv2_web_acl" "portal_waf" {
  name        = "school-portal-waf"
  description = "WAF protection for the school portal"
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  # Protect availability from excessive request volume.
  # 2000 is a lab/design assumption and should be tuned using
  # observed legitimate production traffic.
  rule {
    name     = "portal-rate-limit"
    priority = 1

    action {
      block {}
    }

    statement {
      rate_based_statement {
        limit              = 2000
        aggregate_key_type = "IP"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "portal-rate-limit"
      sampled_requests_enabled   = true
    }
  }

  # Protect against common web application attack patterns.
  rule {
    name     = "aws-common-rule-set"
    priority = 10

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "aws-common-rule-set"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "school-portal-waf"
    sampled_requests_enabled   = true
  }

  tags = {
    Name = "school-portal-waf"
  }
}

resource "aws_wafv2_web_acl_association" "portal_waf_association" {
  resource_arn = aws_lb.portal_alb.arn
  web_acl_arn  = aws_wafv2_web_acl.portal_waf.arn
}

resource "aws_cloudwatch_log_group" "waf_logs" {
  name              = "aws-waf-logs-school-portal"
  retention_in_days = 7

  tags = {
    Name = "school-portal-waf-logs"
  }
}

resource "aws_wafv2_web_acl_logging_configuration" "portal_waf_logging" {
  resource_arn            = aws_wafv2_web_acl.portal_waf.arn
  log_destination_configs = [aws_cloudwatch_log_group.waf_logs.arn]
}