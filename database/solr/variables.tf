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

# Solr detectors specific

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

# errors detectors

variable "errors_disabled" {
  description = "Disable all alerting rules for errors detector"
  type        = bool
  default     = null
}

variable "errors_disabled_critical" {
  description = "Disable critical alerting rule for errors detector"
  type        = bool
  default     = null
}

variable "errors_disabled_warning" {
  description = "Disable warning alerting rule for errors detector"
  type        = bool
  default     = null
}

variable "errors_notifications" {
  description = "Notification recipients list for every alerting rules of errors detector"
  type        = list
  default     = []
}

variable "errors_notifications_warning" {
  description = "Notification recipients list for warning alerting rule of errors detector"
  type        = list
  default     = []
}

variable "errors_notifications_critical" {
  description = "Notification recipients list for critical alerting rule of errors detector"
  type        = list
  default     = []
}

variable "errors_aggregation_function" {
  description = "Aggregation function and group by for errors detector (i.e. \".mean(by=['host'])\")"
  type        = string
  default     = ""
}

variable "errors_transformation_function" {
  description = "Transformation function for errors detector (i.e. \".mean(over='5m')\")"
  type        = string
  default     = ".mean(over='5m')"
}

variable "errors_threshold_critical" {
  description = "Critical threshold for errors detector"
  type        = number
  default     = 5
}

variable "errors_threshold_warning" {
  description = "Warning threshold for errors detector"
  type        = number
  default     = 0
}

# Searcher_warmup_time detectors

variable "searcher_warmup_time_disabled" {
  description = "Disable all alerting rules for searcher_warmup_time detector"
  type        = bool
  default     = null
}

variable "searcher_warmup_time_disabled_critical" {
  description = "Disable critical alerting rule for searcher_warmup_time detector"
  type        = bool
  default     = null
}

variable "searcher_warmup_time_disabled_warning" {
  description = "Disable warning alerting rule for searcher_warmup_time detector"
  type        = bool
  default     = null
}

variable "searcher_warmup_time_notifications" {
  description = "Notification recipients list for every alerting rules of searcher_warmup_time detector"
  type        = list
  default     = []
}

variable "searcher_warmup_time_notifications_warning" {
  description = "Notification recipients list for warning alerting rule of searcher_warmup_time detector"
  type        = list
  default     = []
}

variable "searcher_warmup_time_notifications_critical" {
  description = "Notification recipients list for critical alerting rule of searcher_warmup_time detector"
  type        = list
  default     = []
}

variable "searcher_warmup_time_aggregation_function" {
  description = "Aggregation function and group by for searcher_warmup_time detector (i.e. \".mean(by=['host'])\")"
  type        = string
  default     = ""
}

variable "searcher_warmup_time_transformation_function" {
  description = "Transformation function for searcher_warmup_time detector (i.e. \".mean(over='5m')\")"
  type        = string
  default     = ".max(over='5m')"
}

variable "searcher_warmup_time_threshold_critical" {
  description = "Critical threshold for searcher_warmup_time detector"
  type        = number
  default     = 5000
}

variable "searcher_warmup_time_threshold_warning" {
  description = "Warning threshold for searcher_warmup_time detector"
  type        = number
  default     = 2000
}

