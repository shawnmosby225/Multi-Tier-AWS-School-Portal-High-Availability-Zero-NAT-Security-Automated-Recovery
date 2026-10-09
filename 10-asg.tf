resource "aws_autoscaling_group" "portal_asg" {
  min_size         = 2
  desired_capacity = 2
  max_size         = 6
  name             = "school-portal-asg"

  instance_refresh {
    strategy = "Rolling"

    preferences {
      min_healthy_percentage = 100
    }
  }

  vpc_zone_identifier = [
    aws_subnet.private_app_subnet_a.id,
    aws_subnet.private_app_subnet_b.id
  ]

  target_group_arns = [
    aws_lb_target_group.portal_alb_tg.arn
  ]

  health_check_type         = "ELB"
  health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.portal_app_template.id
    version = aws_launch_template.portal_app_template.latest_version
  }
  tag {
    key                 = "Name"
    value               = "school-portal-app"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "school_portal_policy" {
  autoscaling_group_name = aws_autoscaling_group.portal_asg.name
  name                   = "school-portal-asg"
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ALBRequestCountPerTarget"
      resource_label         = "${aws_lb.portal_alb.arn_suffix}/${aws_lb_target_group.portal_alb_tg.arn_suffix}"
    }
    target_value = 1000
  }
}

resource "aws_autoscaling_schedule" "registration_prescale" {
  scheduled_action_name  = "registration-prescale"
  autoscaling_group_name = aws_autoscaling_group.portal_asg.name

  min_size         = 5
  desired_capacity = 5
  max_size         = 8

  recurrence = "0 7 * * 1"
  time_zone  = "America/Denver"
}

resource "aws_autoscaling_schedule" "registration_scale_down" {
  scheduled_action_name  = "registration-scale-down"
  autoscaling_group_name = aws_autoscaling_group.portal_asg.name

  min_size         = 2
  desired_capacity = 2
  max_size         = 6

  recurrence = "0 12 * * 1"
  time_zone  = "America/Denver"
}