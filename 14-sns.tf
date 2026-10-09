resource "aws_sns_topic" "school_portal_critical_alerts" {
  name = "school-portal-critical-alerts"
}

resource "aws_sns_topic_subscription" "school_portal_subscription" {
  topic_arn = aws_sns_topic.school_portal_critical_alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}