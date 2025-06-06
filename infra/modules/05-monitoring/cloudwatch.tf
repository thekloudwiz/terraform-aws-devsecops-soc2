# Create CloudWatch Log Group for Flow Logs
resource "aws_cloudwatch_log_group" "vpc_flow_logs" {
  name              = "/aws/vpc/flow-logs/${data.aws_ssm_parameter.vpc_id.value}"
  retention_in_days = var.workspace_config[terraform.workspace].flow_logs_retention_days

  lifecycle {
    ignore_changes = [name]
  }

  tags = merge(local.common_tags, {
    Name = "VPC Flow Logs Group"
  })

  #checkov:skip=CKV_AWS_158: "Ensure that CloudWatch Log Group is encrypted by KMS"
  #checkov:skip=CKV_AWS_338: "Ensure CloudWatch log groups retains logs for at least 1 year"
}

# Enable VPC Flow Logs
resource "aws_flow_log" "vpc_flow_logs" {
  log_destination      = aws_cloudwatch_log_group.vpc_flow_logs.arn
  log_destination_type = "cloud-watch-logs"
  traffic_type         = "ALL"
  vpc_id               = data.aws_ssm_parameter.vpc_id.value
  iam_role_arn         = aws_iam_role.vpc_flow_logs_role.arn

  lifecycle {
    ignore_changes = [vpc_id, log_destination]
  }
}

# Application-specific alarms
resource "aws_cloudwatch_metric_alarm" "api_latency" {
  alarm_name          = "${local.name_prefix}-api-latency"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "TargetResponseTime"
  namespace           = "AWS/ApplicationELB"
  period              = 300
  statistic           = "Average"
  threshold           = 1
  alarm_description   = "API latency is too high"
  alarm_actions       = [aws_sns_topic.alerts.arn]

  dimensions = {
    LoadBalancer = data.aws_lb.alb.arn_suffix
  }

  tags = local.common_tags
}

resource "aws_cloudwatch_log_group" "app_logs" {
  name              = "/aws/ecs/app-${data.aws_ecs_cluster.ecs_cluster.cluster_name}-app-logs"
  retention_in_days = var.workspace_config[terraform.workspace].log_retention_days

  tags = merge(local.common_tags, {
    Name = "${local.ecs_cluster_name}-app-logs"
  })

  lifecycle {
    ignore_changes        = [name]
    create_before_destroy = true
  }

  #checkov:skip=CKV_AWS_158: "Ensure that CloudWatch Log Group is encrypted by KMS
}

# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "ecs_logs" {
  name              = "/aws/ecs/${local.ecs_cluster_name}-logs"
  retention_in_days = var.workspace_config[terraform.workspace].log_retention_days
  kms_key_id        = aws_kms_alias.cloudwatch_kms_alias.arn

  tags = merge(local.common_tags, {
    Name = "${local.ecs_cluster_name}-logs"
  })

  lifecycle {
    ignore_changes        = [name]
    create_before_destroy = true
  }

  #checkov:skip=CKV_AWS_66: "Ensure that CloudWatch Log Group specifies retention days"
  #checkov:skip=CKV_AWS_158: "Ensure that CloudWatch Log Group is encrypted by KMS"
}

# Add log metric filter for critical errors
resource "aws_cloudwatch_log_metric_filter" "error_metric" {
  name           = "${local.name_prefix}-error-metric"
  pattern        = "[timestamp, requestid, level=ERROR*, message]"
  log_group_name = aws_cloudwatch_log_group.ecs_logs.name

  metric_transformation {
    name          = "${local.name_prefix}-error-count"
    namespace     = "${local.name_prefix}/Errors"
    value         = "1"
    default_value = "0"
  }

  depends_on = [aws_cloudwatch_log_group.ecs_logs]
}

# CloudWatch Metric Alarms
resource "aws_cloudwatch_metric_alarm" "cpu_utilization" {
  alarm_name          = "${local.ecs_cluster_name}-cpu-utilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "300"
  statistic           = "Average"
  threshold           = var.workspace_config[terraform.workspace].cpu_threshold
  alarm_description   = "This metric monitors ECS CPU utilization"

  dimensions = {
    ClusterName = local.ecs_cluster_name
    ServiceName = "${local.ecs_cluster_name}-service"
  }

  alarm_actions = [aws_sns_topic.alerts.arn]
  ok_actions    = [aws_sns_topic.alerts.arn]

  tags = merge(local.common_tags, {
    Name = "${local.ecs_cluster_name}-cpu-utilization"
  })
}

# Add anomaly detection
resource "aws_cloudwatch_metric_alarm" "cpu_anomaly" {
  alarm_name          = "${local.name_prefix}-cpu-anomaly"
  comparison_operator = "GreaterThanUpperThreshold"
  evaluation_periods  = 2
  threshold_metric_id = "ad1"
  alarm_description   = "CPU utilization is abnormally high"
  alarm_actions       = [data.aws_sns_topic.alerts.arn]

  metric_query {
    id          = "m1"
    return_data = true
    metric {
      metric_name = "CPUUtilization"
      namespace   = "AWS/ECS"
      period      = 300
      stat        = "Average"
      dimensions = {
        ClusterName = local.ecs_cluster_name
        ServiceName = local.ecs_service_name
      }
    }
  }

  metric_query {
    id          = "ad1"
    expression  = "ANOMALY_DETECTION_BAND(m1, 2)"
    label       = "CPUUtilization(Expected)"
    return_data = true
  }

  tags = local.common_tags
}

# CloudWatch Metric Alarm for Memory Utilization
resource "aws_cloudwatch_metric_alarm" "memory_utilization" {
  alarm_name          = "${data.aws_ecs_cluster.ecs_cluster.cluster_name}-memory-utilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/ECS"
  period              = "300"
  statistic           = "Average"
  threshold           = var.workspace_config[terraform.workspace].memory_threshold
  alarm_description   = "This metric monitors ECS memory utilization"

  dimensions = {
    ClusterName = data.aws_ecs_cluster.ecs_cluster.cluster_name
    ServiceName = "${data.aws_ecs_cluster.ecs_cluster.cluster_name}-service"
  }

  alarm_actions = [data.aws_sns_topic.alerts.arn]
  ok_actions    = [data.aws_sns_topic.alerts.arn]

  tags = merge(local.common_tags, {
    Name = "${local.ecs_cluster_name}-memory-utilization"
  })
}

# CloudWatch Dashboard
resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "${data.aws_ecs_cluster.ecs_cluster.cluster_name}-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6

        properties = {
          metrics = [
            ["AWS/ECS", "CPUUtilization", "ClusterName", data.aws_ecs_cluster.ecs_cluster.cluster_name, { "stat" : "Sum" }],
            ["AWS/ECS", "MemoryUtilization", "ClusterName", data.aws_ecs_cluster.ecs_cluster.cluster_name, { "stat" : "Sum" }]
          ]
          period = 120
          stat   = "Sum"
          region = var.primary_region
          title  = "ECS Cluster Utilization"
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = 12
        height = 6

        properties = {
          metrics = [
            ["AWS/ApplicationELB", "RequestCount", "LoadBalancer", data.aws_lb.alb.arn_suffix],
            [".", "HTTPCode_Target_4XX_Count", ".", "."],
            [".", "HTTPCode_Target_5XX_Count", ".", "."]
          ]
          period = 300
          stat   = "Sum"
          region = var.primary_region
          title  = "ALB Metrics"
        }
      }
    ]
  })
}

# Security and Performance Dashboard
resource "aws_cloudwatch_dashboard" "security_performance" {
  dashboard_name = "${local.name_prefix}-security-performance"

  dashboard_body = jsonencode({
    widgets = [
      # Security Metrics Section
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6
        properties = {
          view    = "timeSeries"
          stacked = false
          metrics = [
            ["AWS/WAFV2", "BlockedRequests", "WebACL", data.aws_ssm_parameter.waf_acl_id.value, { "stat" : "Sum" }],
            ["AWS/WAFV2", "AllowedRequests", "WebACL", data.aws_ssm_parameter.waf_acl_id.value, { "stat" : "Sum" }]
          ]
          region = var.primary_region
          title  = "WAF Requests (Blocked vs Allowed)"
          period = 300
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = 12
        height = 6
        properties = {
          view = "timeSeries"
          metrics = [
            ["AWS/GuardDuty", "FindingsCount", "DetectorId", data.aws_ssm_parameter.guardduty_detector_id.value, { "stat" : "Sum" }]
          ]
          region = var.primary_region
          title  = "GuardDuty Findings"
          period = 300
        }
      },
      # ALB Performance Section
      {
        type   = "metric"
        x      = 0
        y      = 6
        width  = 12
        height = 6
        properties = {
          view = "timeSeries"
          metrics = [
            ["AWS/ApplicationELB", "TargetResponseTime", "LoadBalancer", data.aws_lb.alb.arn_suffix],
            ["AWS/ApplicationELB", "RequestCount", "LoadBalancer", data.aws_lb.alb.arn_suffix]
          ]
          region = var.primary_region
          title  = "ALB Performance"
          period = 60
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 6
        width  = 12
        height = 6
        properties = {
          view = "timeSeries"
          metrics = [
            ["AWS/ECS", "CPUUtilization", "ClusterName", data.aws_ecs_cluster.ecs_cluster.cluster_name, { "stat" : "Average" }],
            ["AWS/ECS", "MemoryUtilization", "ClusterName", data.aws_ecs_cluster.ecs_cluster.cluster_name, { "stat" : "Average" }]
          ]
          region = var.primary_region
          title  = "ECS Cluster Performance"
          period = 60
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 12
        width  = 12
        height = 6
        properties = {
          view = "timeSeries"
          metrics = [
            ["AWS/ECS", "RunningTaskCount", "ClusterName", local.ecs_cluster_name, { "stat" : "Average" }],
            ["AWS/ECS", "PendingTaskCount", "ClusterName", local.ecs_cluster_name, { "stat" : "Average" }],
            ["AWS/ECS", "CPUReservation", "ClusterName", local.ecs_cluster_name, { "stat" : "Average" }],
            ["AWS/ECS", "MemoryReservation", "ClusterName", local.ecs_cluster_name, { "stat" : "Average" }]
          ]
          region = var.primary_region
          title  = "ECS Cluster Utilization"
        }
      },
      # Error Tracking Section
      {
        type   = "log"
        x      = 0
        y      = 12
        width  = 24
        height = 6
        properties = {
          query  = "SOURCE '${aws_cloudwatch_log_group.ecs_logs.name}' | fields @timestamp, @message | filter @message like /ERROR|CRITICAL|ALERT|EMERGENCY/"
          region = var.primary_region
          title  = "Critical Application Errors"
          view   = "table"
        }
      },
      # Security Events Section
      {
        type   = "metric"
        x      = 0
        y      = 18
        width  = 12
        height = 6
        properties = {
          view = "timeSeries"
          metrics = [
            ["${local.name_prefix}/Errors", "${local.name_prefix}-error-count", { "stat" : "Sum" }]
          ]
          region = var.primary_region
          title  = "Security Events Count"
          period = 300
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 18
        width  = 12
        height = 6
        properties = {
          view = "timeSeries"
          metrics = [
            ["AWS/ECS", "RunningTaskCount", "ClusterName", local.ecs_cluster_name],
            ["AWS/ECS", "PendingTaskCount", "ClusterName", local.ecs_cluster_name]
          ]
          region = var.primary_region
          title  = "Container Health"
          period = 300
        }
      }
    ]
  })
}

# Add CloudWatch Alarms for Security Events
resource "aws_cloudwatch_metric_alarm" "security_events" {
  alarm_name          = "${local.name_prefix}-security-events"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "${local.name_prefix}-error-count"
  namespace           = "${local.name_prefix}/Errors"
  period              = "300"
  statistic           = "Sum"
  threshold           = "10"
  alarm_description   = "This metric monitors security-related events"
  alarm_actions       = [data.aws_sns_topic.alerts.arn]

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-security-events"
  })
}

# CloudWatch Composite Alarm for Critical Security Issues
resource "aws_cloudwatch_composite_alarm" "critical_security" {
  alarm_name        = "${local.name_prefix}-critical-security"
  alarm_description = "Composite alarm for critical security issues"

  alarm_rule = "ALARM(${aws_cloudwatch_metric_alarm.cpu_anomaly.alarm_name}) OR ALARM(${aws_cloudwatch_metric_alarm.memory_utilization.alarm_name})"


  alarm_actions = [
    data.aws_sns_topic.alerts.arn
  ]

  ok_actions = [
    data.aws_sns_topic.alerts.arn
  ]

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-critical-security"
  })
}

# Add CloudWatch Insights Query for Security Analysis
resource "aws_cloudwatch_query_definition" "security_analysis" {
  name = "${local.name_prefix}-security-analysis"

  log_group_names = [
    data.aws_cloudwatch_log_group.app_logs.name,
    aws_cloudwatch_log_group.ecs_logs.name
  ]

  query_string = <<-EOF
    fields @timestamp, @message, @logStream, @log
    | filter @message like /SECURITY|ERROR|CRITICAL|ALERT|EMERGENCY/
    | sort @timestamp desc
    | limit 100
  EOF
}