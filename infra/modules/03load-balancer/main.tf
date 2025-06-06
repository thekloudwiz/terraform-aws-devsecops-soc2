
# Target Group
resource "aws_lb_target_group" "ecs_target_group" {
  name        = local.target_group_name
  port        = var.container_port
  protocol    = "HTTP"
  vpc_id      = data.aws_ssm_parameter.vpc_id.value
  target_type = "ip"

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  lifecycle {
    ignore_changes = [
      name,
      port,
      protocol,
      target_type,
      vpc_id
    ]
    create_before_destroy = true
  }

  tags = merge(local.common_tags, {
    Name = local.target_group_name
  })

  #checkov:skip=CKV_AWS_378: "Ensure AWS Load Balancer doesn't use HTTP protocol"
}

# Create the ALB
resource "aws_lb" "alb" {
  name               = local.alb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [data.aws_ssm_parameter.alb_sg_id.value]
  subnets            = split(",", data.aws_ssm_parameter.public_subnet_ids.value)

  # Ensure that ALB drops HTTP headers
  drop_invalid_header_fields = true

  access_logs {
    bucket  = aws_s3_bucket.alb_logs.id
    prefix  = terraform.workspace
    enabled = true
  }

  enable_deletion_protection = terraform.workspace == "prod" ? true : false

  tags = merge(local.common_tags, {
    Name = local.alb_name
  })
  #checkov:skip=CKV_AWS_150: "Ensure that Load Balancer has deletion protection enabled"
  #checkov:skip=CKV_AWS_131: "Ensure that ALB drops HTTP headers"
  #checkov:skip=CKV2_AWS_20: "Ensure that ALB redirects HTTP requests into HTTPS ones"
}

# HTTP to HTTPS redirect
resource "aws_lb_listener" "http_redirect" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "redirect"
    target_group_arn = aws_lb_target_group.ecs_target_group.arn

    redirect {
      protocol    = "HTTPS"
      port        = var.container_port
      status_code = "HTTP_301"
    }
  }
}

# HTTPS Listener (Handles Secure Traffic)
resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = var.alb_https_listener_port
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = data.aws_acm_certificate.acm_cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_target_group.arn
  }
}

# # Create ALB Listener for HTTP (handles HTTP traffic)
# resource "aws_lb_listener" "http_listener" {
#   load_balancer_arn = aws_lb.alb.arn
#   port              = 80
#   protocol          = "HTTP"

#   default_action {
#     type = "forward"
#     target_group_arn = aws_lb_target_group.ecs_target_group.arn
#   }
# }

# Associate WAF with ALB
resource "aws_wafv2_web_acl_association" "waf_alb_association" {
  resource_arn = aws_ssm_parameter.alb_arn.value
  web_acl_arn  = data.aws_ssm_parameter.waf_acl_arn.value
}

