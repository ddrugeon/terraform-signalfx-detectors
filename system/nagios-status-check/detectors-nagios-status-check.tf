resource "signalfx_detector" "status_check" {
  name = "${join("", formatlist("[%s]", var.prefixes))}[${var.environment}] Nagios check status"

  program_text = <<-EOF
        signal = data('nagios_state.state', filter=${module.filter-tags.filter_custom})${var.status_check_aggregation_function}${var.status_check_transformation_function}.publish('signal')
        detect(when(signal >= threshold(1)) and when(signal < 2)).publish('WARN')
        detect(when(signal >= threshold(2)) and when(signal < 3)).publish('CRIT')
        detect(when(signal >= threshold(3))).publish('UNKN')
  EOF

  rule {
    description           = "is UNKNOWN, please check the script output on the host"
    severity              = "Critical"
    detect_label          = "UNKN"
    disabled              = coalesce(var.status_check_disabled_critical, var.status_check_disabled, var.detectors_disabled)
    notifications         = coalescelist(var.status_check_notifications_critical, var.status_check_notifications, var.notifications)
    parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{readableRule}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
  }

  rule {
    description           = "is CRITICAL, please check the script output on the host"
    severity              = "Critical"
    detect_label          = "CRIT"
    disabled              = coalesce(var.status_check_disabled_critical, var.status_check_disabled, var.detectors_disabled)
    notifications         = coalescelist(var.status_check_notifications_critical, var.status_check_notifications, var.notifications)
    parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{readableRule}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
  }

  rule {
    description           = "is WARNING, please check the script output on the host"
    severity              = "Warning"
    detect_label          = "WARN"
    disabled              = coalesce(var.status_check_disabled_warning, var.status_check_disabled, var.detectors_disabled)
    notifications         = coalescelist(var.status_check_notifications_warning, var.status_check_notifications, var.notifications)
    parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{readableRule}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
  }
}
