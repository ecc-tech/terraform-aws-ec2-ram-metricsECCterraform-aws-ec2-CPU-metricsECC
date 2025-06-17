locals {
  cpu_alarm_configs = merge([
    for inst in var.instances : {
      for threshold in var.cpu_thresholds :
      "${inst.instance_id}-${threshold}" => {
        instance_id   = inst.instance_id
        os_type       = inst.os_type
        threshold     = threshold
        image_id      = inst.image_id
        instance_type = inst.instance_type
      }
    }
  ]...)

  get_dimensions = {
    for key, val in local.cpu_alarm_configs : key => val.os_type == "windows" ? {
      InstanceId   = val.instance_id
      instance     = "_Total"
      objectname   = "Processor"
      ImageId      = val.image_id      # You must include this in var.instances
      InstanceType = val.instance_type # You must include this in var.instances
      } : {
      InstanceId = val.instance_id
    }
  }

  metric_config = {
    windows = {
      metric_name = "Processor % Processor Time"
      namespace   = "CWAgent"
    }
    linux = {
      metric_name = "cpu_usage_active"
      namespace   = "CWAgent"
    }
  }
}

resource "aws_cloudwatch_metric_alarm" "cpu_alarm" {
  for_each = local.cpu_alarm_configs

  alarm_name          = "CPU-${each.value.instance_id}-${each.value.threshold}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = local.metric_config[each.value.os_type].metric_name
  namespace           = local.metric_config[each.value.os_type].namespace
  period              = 300
  statistic           = "Average"
  threshold           = each.value.threshold
  alarm_description   = "CPU alarm for ${each.value.os_type} instance at ${each.value.threshold}%"
  dimensions          = local.get_dimensions[each.key]
  treat_missing_data  = "notBreaching"
  actions_enabled     = true
  alarm_actions       = var.sns_topic_arns
}
