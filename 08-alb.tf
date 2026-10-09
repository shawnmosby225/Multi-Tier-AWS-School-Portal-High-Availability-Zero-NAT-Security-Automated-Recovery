resource "aws_lb" "portal_alb" {
  name               = "portal-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_security_group.id]
  subnets = [aws_subnet.public_subnet_a.id,
    aws_subnet.public_subnet_b.id
  ]
}

resource "aws_lb_target_group" "portal_alb_tg" {
  name     = "portal-alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.portal_vpc.id

  health_check {
    path                = "/health"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "portal_listener" {
  load_balancer_arn = aws_lb.portal_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "portal_https_listener" {
  load_balancer_arn = aws_lb.portal_alb.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate.portal_certificate.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.portal_alb_tg.arn
  }
}