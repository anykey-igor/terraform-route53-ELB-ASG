resource "aws_route53_record" "www" {
  zone_id = "Z0024400C15GKK3Q8HT2"
  name    = "younet.com.ua"
  type    = "A"

  alias {
    name                   = aws_lb.alb.dns_name
    zone_id                = aws_lb.alb.zone_id
    evaluate_target_health = true
  }
}

output "alb_dns_name" {
    description = "Domain name ALB"
    value = aws_lb.alb.dns_name
}
