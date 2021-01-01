terraform {
  required_version = ">= 0.12, < 0.13"
}

resource "aws_lb" "personal_front_end" {
  name = var.alb_name
  load_balancer_type = local.application
  subnets = local.subnet_ids
  internal = var.internal
  security_groups = [aws_security_group.alb.id]
}

resource "aws_lb_target_group" "front_end" {
  name = var.alb_name
  port = local.http_port
  protocol = "HTTP"
  vpc_id = local.vpc_id
  target_type = var.target_type
  health_check {
    path = "/"
    protocol = "HTTP"
    matcher = "200"
    interval = 30
    timeout = 10
    healthy_threshold = 2
    unhealthy_threshold = 2
  }

  # https://github.com/cds-snc/aws-ecs-fargate/issues/1
  depends_on = [aws_lb.personal_front_end]
  # stickiness?
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.personal_front_end.arn
  port = local.http_port
  protocol = "HTTP"
  default_action {
    type = "redirect"
    redirect {
      port = "443"
      protocol = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

data "aws_acm_certificate" "issued" {
  domain = var.acm_domain_certificate
  statuses = ["ISSUED"]
}

resource "aws_lb_listener" "front_end_ssl" {
  load_balancer_arn = aws_lb.personal_front_end.arn
  port = local.https_port
  protocol = "HTTPS"
  ssl_policy = local.elb_security_policy
  certificate_arn = data.aws_acm_certificate.issued.arn
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.front_end.arn

  }
}

resource "aws_security_group" "alb" {
  name = var.alb_name
}
resource "aws_security_group_rule" "allow_http_inbound" {
  type = "ingress"
  security_group_id = aws_security_group.alb.id
  from_port = local.http_port
  to_port = local.http_port
  protocol = local.tcp_protocol
  cidr_blocks = local.all_ips
}

resource "aws_security_group_rule" "allow_http_outbound" {
  type = "egress"
  security_group_id = aws_security_group.alb.id
  from_port = local.http_port
  to_port = local.http_port
  protocol = local.tcp_protocol
  cidr_blocks = local.all_ips
}

resource "aws_security_group_rule" "allow_https_inbound" {
  type = "ingress"
  security_group_id = aws_security_group.alb.id
  from_port = local.https_port
  to_port = local.https_port
  protocol = local.tcp_protocol
  cidr_blocks = local.all_ips
}

resource "aws_security_group_rule" "allow_https_outbound" {
  type = "egress"
  security_group_id = aws_security_group.alb.id
  from_port = local.https_port
  to_port = local.https_port
  protocol = local.tcp_protocol
  cidr_blocks = local.all_ips
}

locals {
  application = "application"
  http_port = 80
  https_port = 443
  tcp_protocol = "tcp"
  all_ips = ["0.0.0.0/0"]
  elb_security_policy = "ELBSecurityPolicy-2016-08"
}