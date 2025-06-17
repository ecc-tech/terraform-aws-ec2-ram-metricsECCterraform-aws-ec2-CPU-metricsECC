
output "cpu_alarms" {
  description = "Map of created CPU alarms with their configurations"
  value = {
    for k, alarm in aws_cloudwatch_metric_alarm.cpu_alarm : k => {
      alarm_name  = alarm.alarm_name
      alarm_arn   = alarm.arn
      instance_id = alarm.dimensions.InstanceId
      threshold   = alarm.threshold
      metric_name = alarm.metric_name
      namespace   = alarm.namespace
    }
  }
}

output "cpu_alarm_names" {
  description = "List of created CPU alarm names"
  value       = [for alarm in aws_cloudwatch_metric_alarm.cpu_alarm : alarm.alarm_name]
}

output "alarm_count" {
  description = "Total number of CPU alarms created"
  value       = length(aws_cloudwatch_metric_alarm.cpu_alarm)
}