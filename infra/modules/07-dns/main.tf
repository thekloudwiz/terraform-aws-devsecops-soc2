# Create DNS Record for Portfolio Domain
resource "aws_route53_record" "portfolio_domain" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = var.portfolio_domain_name
  type    = "A"

  alias {
    name                   = "dualstack.${data.aws_ssm_parameter.alb_dns_name.value}"
    zone_id                = data.aws_ssm_parameter.alb_zone_id.value
    evaluate_target_health = false
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      name,
      zone_id
    ]
  }
}