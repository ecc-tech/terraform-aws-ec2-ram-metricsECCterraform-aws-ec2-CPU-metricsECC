variable "cpu_thresholds" {
  description = "List of CPU thresholds to create alarms for"
  type        = list(number)
  default     = [70, 80, 90]
}

variable "instances" {
  description = "List of instances with metadata"
  type = list(object({
    instance_id   = string
    os_type       = string
    name          = string
    image_id      = string
    instance_type = string
    ami_name      = string
  }))
}




variable "sns_topic_arns" {
  description = "List of SNS topic ARNs for alarm actions."
  type        = list(string)
}
