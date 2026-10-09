resource "aws_cloudwatch_metric_alarm" "healthy_app_loss" {
  alarm_name          = "healthy-app-loss"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  metric_name         = "HealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Average"
  threshold           = 1
  alarm_description   = "Critical: ALB target group has no healthy application targets"
  treat_missing_data  = "breaching"
  alarm_actions = [
    aws_sns_topic.school_portal_critical_alerts.arn
  ]
  dimensions = {
    TargetGroup  = aws_lb_target_group.portal_alb_tg.arn_suffix
    LoadBalancer = aws_lb.portal_alb.arn_suffix
  }
  ok_actions = [
    aws_sns_topic.school_portal_critical_alerts.arn
  ]
}

resource "aws_cloudwatch_metric_alarm" "high_5xx_error_alarm" {
  alarm_name          = "high-5xx-error-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "HTTPCode_Target_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Sum"
  threshold           = 10
  alarm_description   = "Critical: ALB is showing more than 10 500 errors"
  treat_missing_data  = "notBreaching"
  alarm_actions = [
    aws_sns_topic.school_portal_critical_alerts.arn
  ]
  dimensions = {
    TargetGroup  = aws_lb_target_group.portal_alb_tg.arn_suffix
    LoadBalancer = aws_lb.portal_alb.arn_suffix
  }
  ok_actions = [
    aws_sns_topic.school_portal_critical_alerts.arn
  ]
}

resource "aws_cloudwatch_metric_alarm" "high_target_response_average" {
  alarm_name          = "high-target-response-average"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 3
  metric_name         = "TargetResponseTime"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Average"
  threshold           = 10
  alarm_description   = "Critical: Application average is taking longer than 10 seconds"
  treat_missing_data  = "notBreaching"
  alarm_actions = [
    aws_sns_topic.school_portal_critical_alerts.arn
  ]
  dimensions = {
    TargetGroup  = aws_lb_target_group.portal_alb_tg.arn_suffix
    LoadBalancer = aws_lb.portal_alb.arn_suffix
  }
  ok_actions = [
    aws_sns_topic.school_portal_critical_alerts.arn
  ]
}

resource "aws_cloudwatch_metric_alarm" "high_database_connections" {
  alarm_name          = "high-database-connections"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 4
  metric_name         = "DatabaseConnections"
  namespace           = "AWS/RDS"
  period              = 60
  statistic           = "Average"
  threshold           = 49
  alarm_description   = "Critical: Average database connections reached at least 49 for 4 consecutive minutes."
  treat_missing_data  = "notBreaching"
  alarm_actions = [
    aws_sns_topic.school_portal_critical_alerts.arn
  ]
  dimensions = {
    DBInstanceIdentifier = aws_db_instance.portal_db.identifier
  }
  ok_actions = [
    aws_sns_topic.school_portal_critical_alerts.arn
  ]
}

resource "aws_cloudwatch_metric_alarm" "low_freeable_memory" {
  alarm_name          = "low-freeable-memory"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 3
  metric_name         = "FreeableMemory"
  namespace           = "AWS/RDS"
  period              = 60
  statistic           = "Average"
  threshold           = 52428800
  alarm_description   = "Critical: Average RDS freeable memory remained below 50 MiB for 3 consecutive minutes."
  treat_missing_data  = "notBreaching"
  alarm_actions = [
    aws_sns_topic.school_portal_critical_alerts.arn
  ]
  dimensions = {
    DBInstanceIdentifier = aws_db_instance.portal_db.identifier
  }
  ok_actions = [
    aws_sns_topic.school_portal_critical_alerts.arn
  ]
}

resource "aws_cloudwatch_metric_alarm" "low_database_storage" {
  alarm_name          = "low-database-storage"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 5

  metric_name = "FreeStorageSpace"
  namespace   = "AWS/RDS"
  period      = 60
  statistic   = "Average"

  threshold = 10737418240

  alarm_description = "Critical: RDS free storage remained below 10 GiB for 5 consecutive minutes."

  treat_missing_data = "notBreaching"

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.portal_db.identifier
  }

  alarm_actions = [
    aws_sns_topic.school_portal_critical_alerts.arn
  ]

  ok_actions = [
    aws_sns_topic.school_portal_critical_alerts.arn
  ]
}