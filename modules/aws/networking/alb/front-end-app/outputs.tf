output "alb_dns_name" {
  value = aws_lb.personal_front_end.dns_name
  description = "The domain name of the load balancer"
}

output "alb_arn" {
  value = aws_lb_target_group.front_end.arn
  description = "The aws lb target group arn"
}

output "alb_security_group" {
  value = aws_security_group.alb.id
  description = "Security group for the ALB"
}

