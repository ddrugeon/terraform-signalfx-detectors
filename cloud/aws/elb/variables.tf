# Global

variable "environment" {
  description = "Infrastructure environment"
  type        = string
}

# SignalFx module specific

variable "notifications" {
  description = "Notification recipients list for every detectors"
  type        = list
}

variable "prefixes" {
  description = "Prefixes list to prepend between brackets on every monitors names before environment"
  type        = list
  default     = []
}

variable "filter_custom_includes" {
  description = "List of tags to include when custom filtering is used"
  type        = list
  default     = []
}

variable "filter_custom_excludes" {
  description = "List of tags to exclude when custom filtering is used"
  type        = list
  default     = []
}

variable "detectors_disabled" {
  description = "Disable all detectors in this module"
  type        = bool
  default     = false
}

# AWS ELB detectors specific

variable "minimum_traffic" {
  description = "Minimum required traffic to evaluate rate of errors detectors"
  type        = number
  default     = 4
}

variable "heartbeat_disabled" {
  description = "Disable all alerting rules for heartbeat detector"
  type        = bool
  default     = null
}

variable "heartbeat_notifications" {
  description = "Notification recipients list for every alerting rules of heartbeat detector"
  type        = list
  default     = []
}

variable "heartbeat_timeframe" {
  description = "Timeframe for system not reporting detector (i.e. \"10m\")"
  type        = string
  default     = "20m"
}

# no_healthy_instances detectors

variable "no_healthy_instances_disabled" {
  description = "Disable all alerting rules for no_healthy_instances detector"
  type        = bool
  default     = null
}

variable "no_healthy_instances_disabled_critical" {
  description = "Disable critical alerting rule for no_healthy_instances detector"
  type        = bool
  default     = null
}

variable "no_healthy_instances_disabled_warning" {
  description = "Disable warning alerting rule for no_healthy_instances detector"
  type        = bool
  default     = null
}

variable "no_healthy_instances_notifications" {
  description = "Notification recipients list for every alerting rules of no_healthy_instances detector"
  type        = list
  default     = []
}

variable "no_healthy_instances_notifications_warning" {
  description = "Notification recipients list for warning alerting rule of no_healthy_instances detector"
  type        = list
  default     = []
}

variable "no_healthy_instances_notifications_critical" {
  description = "Notification recipients list for critical alerting rule of no_healthy_instances detector"
  type        = list
  default     = []
}

variable "no_healthy_instances_aggregation_function" {
  description = "Aggregation function and group by for no_healthy_instances detector (i.e. \".mean(by=['host'])\")"
  type        = string
  default     = ""
}

variable "no_healthy_instances_transformation_function" {
  description = "Transformation function for no_healthy_instances detector (i.e. \".mean(over='5m')\"))"
  type        = string
  default     = ".min(over='5m')"
}

variable "no_healthy_instances_threshold_critical" {
  description = "Critical threshold for no_healthy_instances detector"
  type        = number
  default     = 1
}

variable "no_healthy_instances_threshold_warning" {
  description = "Warning threshold for no_healthy_instances detector"
  type        = number
  default     = 100
}

# 4xx detectors

variable "elb_4xx_disabled" {
  description = "Disable all alerting rules for 4xx detector"
  type        = bool
  default     = null
}

variable "elb_4xx_disabled_critical" {
  description = "Disable critical alerting rule for 4xx detector"
  type        = bool
  default     = null
}

variable "elb_4xx_disabled_warning" {
  description = "Disable warning alerting rule for httpcode 4xx erros detector"
  type        = bool
  default     = null
}

variable "elb_4xx_notifications" {
  description = "Notification recipients list for every alerting rules of 4xx detector"
  type        = list
  default     = []
}

variable "elb_4xx_notifications_warning" {
  description = "Notification recipients list for warning alerting rule of 4xx detector"
  type        = list
  default     = []
}

variable "elb_4xx_notifications_critical" {
  description = "Notification recipients list for critical alerting rule of 4xx detector"
  type        = list
  default     = []
}

variable "elb_4xx_aggregation_function" {
  description = "Aggregation function and group by for elb_4xx detector (i.e. \".mean(by=['host'])\")"
  type        = string
  default     = ""
}

variable "elb_4xx_transformation_function" {
  description = "Transformation function for elb_4xx detector (i.e. \".mean(over='5m')\"))"
  type        = string
  default     = ""
}

variable "elb_4xx_lasting_duration_seconds" {
  description = "Minimum duration that conditions must be true before raising alert (in seconds)"
  type        = number
  default     = 300
}

variable "elb_4xx_at_least_percentage" {
  description = "Percentage of lasting that conditions must be true before raising alert (>= 0.0 and <= 1.0)"
  type        = number
  default     = 0.9
}

variable "elb_4xx_threshold_critical" {
  description = "Critical threshold for 4xx detector"
  type        = number
  default     = 40
}

variable "elb_4xx_threshold_warning" {
  description = "Warning threshold for 4xx detector"
  type        = number
  default     = 20
}

# 5xx detectors

variable "elb_5xx_disabled" {
  description = "Disable all alerting rules for 5xx detector"
  type        = bool
  default     = null
}

variable "elb_5xx_disabled_critical" {
  description = "Disable critical alerting rule for 5xx detector"
  type        = bool
  default     = null
}

variable "elb_5xx_disabled_warning" {
  description = "Disable warning alerting rule for 5xx detector"
  type        = bool
  default     = null
}

variable "elb_5xx_notifications" {
  description = "Notification recipients list for every alerting rules of 5xx detector"
  type        = list
  default     = []
}

variable "elb_5xx_notifications_warning" {
  description = "Notification recipients list for warning alerting rule of 5xx detector"
  type        = list
  default     = []
}

variable "elb_5xx_notifications_critical" {
  description = "Notification recipients list for critical alerting rule of 5xx detector"
  type        = list
  default     = []
}

variable "elb_5xx_aggregation_function" {
  description = "Aggregation function and group by for elb_5xx detector (i.e. \".mean(by=['host'])\")"
  type        = string
  default     = ""
}

variable "elb_5xx_transformation_function" {
  description = "Transformation function for elb_5xx detector (i.e. \".mean(over='5m')\"))"
  type        = string
  default     = ""
}

variable "elb_5xx_lasting_duration_seconds" {
  description = "Minimum duration that conditions must be true before raising alert (in seconds)"
  type        = number
  default     = 300
}

variable "elb_5xx_at_least_percentage" {
  description = "Percentage of lasting that conditions must be true before raising alert (>= 0.0 and <= 1.0)"
  type        = number
  default     = 0.9
}

variable "elb_5xx_threshold_critical" {
  description = "Critical threshold for 5xx detector"
  type        = number
  default     = 10
}

variable "elb_5xx_threshold_warning" {
  description = "Warning threshold for 5xx detector"
  type        = number
  default     = 5
}

# backend_4xx detectors

variable "backend_4xx_disabled" {
  description = "Disable all alerting rules for backend_4xx detector"
  type        = bool
  default     = null
}

variable "backend_4xx_disabled_critical" {
  description = "Disable critical alerting rule for backend_4xx detector"
  type        = bool
  default     = null
}

variable "backend_4xx_disabled_warning" {
  description = "Disable warning alerting rule for backend_4xx detector"
  type        = bool
  default     = null
}

variable "backend_4xx_notifications" {
  description = "Notification recipients list for every alerting rules of backend_4xx detector"
  type        = list
  default     = []
}

variable "backend_4xx_notifications_warning" {
  description = "Notification recipients list for warning alerting rule of backend_4xx detector"
  type        = list
  default     = []
}

variable "backend_4xx_notifications_critical" {
  description = "Notification recipients list for critical alerting rule of backend_4xx detector"
  type        = list
  default     = []
}

variable "backend_4xx_aggregation_function" {
  description = "Aggregation function and group by for backend_4xx detector (i.e. \".mean(by=['host'])\")"
  type        = string
  default     = ""
}

variable "backend_4xx_transformation_function" {
  description = "Transformation function for backend_4xx detector (i.e. \".mean(over='5m')\"))"
  type        = string
  default     = ""
}

variable "backend_4xx_lasting_duration_seconds" {
  description = "Minimum duration that conditions must be true before raising alert (in seconds)"
  type        = number
  default     = 300
}

variable "backend_4xx_at_least_percentage" {
  description = "Percentage of lasting that conditions must be true before raising alert (>= 0.0 and <= 1.0)"
  type        = number
  default     = 0.9
}

variable "backend_4xx_threshold_critical" {
  description = "Critical threshold for backend_4xx detector"
  type        = number
  default     = 40
}

variable "backend_4xx_threshold_warning" {
  description = "Warning threshold for backend_4xx detector"
  type        = number
  default     = 20
}

# backend_5xx detectors

variable "backend_5xx_disabled" {
  description = "Disable all alerting rules for backend_5xx detector"
  type        = bool
  default     = null
}

variable "backend_5xx_disabled_critical" {
  description = "Disable critical alerting rule for backend_5xx detector"
  type        = bool
  default     = null
}

variable "backend_5xx_disabled_warning" {
  description = "Disable warning alerting rule for backend_5xx detector"
  type        = bool
  default     = null
}

variable "backend_5xx_notifications" {
  description = "Notification recipients list for every alerting rules of backend_5xx detector"
  type        = list
  default     = []
}

variable "backend_5xx_notifications_warning" {
  description = "Notification recipients list for warning alerting rule of backend_5xx detector"
  type        = list
  default     = []
}

variable "backend_5xx_notifications_critical" {
  description = "Notification recipients list for critical alerting rule of backend_5xx detector"
  type        = list
  default     = []
}

variable "backend_5xx_aggregation_function" {
  description = "Aggregation function and group by for backend_5xx detector (i.e. \".mean(by=['host'])\")"
  type        = string
  default     = ""
}

variable "backend_5xx_transformation_function" {
  description = "Transformation function for backend_5xx detector (i.e. \".mean(over='5m')\"))"
  type        = string
  default     = ""
}

variable "backend_5xx_lasting_duration_seconds" {
  description = "Minimum duration that conditions must be true before raising alert (in seconds)"
  type        = number
  default     = 300
}

variable "backend_5xx_at_least_percentage" {
  description = "Percentage of lasting that conditions must be true before raising alert (>= 0.0 and <= 1.0)"
  type        = number
  default     = 0.9
}

variable "backend_5xx_threshold_critical" {
  description = "Critical threshold for backend_5xx detector"
  type        = number
  default     = 10
}

variable "backend_5xx_threshold_warning" {
  description = "Warning threshold for backend_5xx detector"
  type        = number
  default     = 5
}

# Backend_latency detectors

variable "backend_latency_disabled" {
  description = "Disable all alerting rules for backend_latency detector"
  type        = bool
  default     = null
}

variable "backend_latency_disabled_critical" {
  description = "Disable critical alerting rule for backend_latency detector"
  type        = bool
  default     = null
}

variable "backend_latency_disabled_warning" {
  description = "Disable warning alerting rule for backend_latency detector"
  type        = bool
  default     = null
}

variable "backend_latency_notifications" {
  description = "Notification recipients list for every alerting rules of backend_latency detector"
  type        = list
  default     = []
}

variable "backend_latency_notifications_warning" {
  description = "Notification recipients list for warning alerting rule of backend_latency detector"
  type        = list
  default     = []
}

variable "backend_latency_notifications_critical" {
  description = "Notification recipients list for critical alerting rule of backend_latency detector"
  type        = list
  default     = []
}

variable "backend_latency_aggregation_function" {
  description = "Aggregation function and group by for backend_latency detector (i.e. \".mean(by=['host'])\")"
  type        = string
  default     = ""
}

variable "backend_latency_transformation_function" {
  description = "Transformation function for backend_latency detector (i.e. \".mean(over='5m')\"))"
  type        = string
  default     = ""
}

variable "backend_latency_lasting_duration_seconds" {
  description = "Minimum duration that conditions must be true before raising alert (in seconds)"
  type        = number
  default     = 600
}

variable "backend_latency_at_least_percentage" {
  description = "Percentage of lasting that conditions must be true before raising alert (>= 0.0 and <= 1.0)"
  type        = number
  default     = 0.9
}

variable "backend_latency_threshold_critical" {
  description = "Critical threshold for backend_latency detector"
  type        = number
  default     = 3
}

variable "backend_latency_threshold_warning" {
  description = "Warning threshold for backend_latency detector"
  type        = number
  default     = 1
}

