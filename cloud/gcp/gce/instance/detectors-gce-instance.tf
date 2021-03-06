resource "signalfx_detector" "heartbeat" {
  name = "${join("", formatlist("[%s]", var.prefixes))}[${var.environment}] GCP GCE Instance heartbeat"

  program_text = <<-EOF
    from signalfx.detectors.not_reporting import not_reporting
    signal = data('instance/cpu/usage_time', filter=(not filter('gcp_status', '{Code=3, Name=STOPPING}', '{Code=4, Name=TERMINATED}')) and ${module.filter-tags.filter_custom}).publish('signal')
    not_reporting.detector(stream=signal, resource_identifier=None, duration='${var.heartbeat_timeframe}').publish('CRIT')
EOF

  rule {
    description           = "has not reported in ${var.heartbeat_timeframe}"
    severity              = "Critical"
    detect_label          = "CRIT"
    disabled              = coalesce(var.heartbeat_disabled, var.detectors_disabled)
    notifications         = coalescelist(var.heartbeat_notifications, var.notifications)
    parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{readableRule}}} on {{{dimensions}}}"
  }
}

resource "signalfx_detector" "cpu_utilization" {
  name = "${join("", formatlist("[%s]", var.prefixes))}[${var.environment}] GCP GCE Instance CPU utilization"

  program_text = <<-EOF
    signal = data('instance/cpu/utilization', ${module.filter-tags.filter_custom})${var.cpu_utilization_aggregation_function}${var.cpu_utilization_transformation_function}.scale(100).publish('signal')
    detect(when(signal > ${var.cpu_utilization_threshold_critical})).publish('CRIT')
    detect(when(signal > ${var.cpu_utilization_threshold_warning}) and when(signal <= ${var.cpu_utilization_threshold_critical})).publish('WARN')
EOF

  rule {
    description           = "is too high > ${var.cpu_utilization_threshold_critical}"
    severity              = "Critical"
    detect_label          = "CRIT"
    disabled              = coalesce(var.cpu_utilization_disabled_critical, var.cpu_utilization_disabled, var.detectors_disabled)
    notifications         = coalescelist(var.cpu_utilization_notifications_critical, var.cpu_utilization_notifications, var.notifications)
    parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{readableRule}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
  }

  rule {
    description           = "is too high > ${var.cpu_utilization_threshold_warning}"
    severity              = "Warning"
    detect_label          = "WARN"
    disabled              = coalesce(var.cpu_utilization_disabled_warning, var.cpu_utilization_disabled, var.detectors_disabled)
    notifications         = coalescelist(var.cpu_utilization_notifications_warning, var.cpu_utilization_notifications, var.notifications)
    parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{readableRule}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
  }
}

resource "signalfx_detector" "disk_throttled_bps" {
  name = "${join("", formatlist("[%s]", var.prefixes))}[${var.environment}] GCP GCE Instance disk throttled bps"

  program_text = <<-EOF
    A = data('instance/disk/throttled_read_bytes_count', ${module.filter-tags.filter_custom})${var.disk_throttled_bps_aggregation_function}${var.disk_throttled_bps_transformation_function}
    B = data('instance/disk/throttled_write_bytes_count', ${module.filter-tags.filter_custom})${var.disk_throttled_bps_aggregation_function}${var.disk_throttled_bps_transformation_function}
    C = data('instance/disk/read_bytes_count', ${module.filter-tags.filter_custom})${var.disk_throttled_bps_aggregation_function}${var.disk_throttled_bps_transformation_function}
    D = data('instance/disk/write_bytes_count', ${module.filter-tags.filter_custom})${var.disk_throttled_bps_aggregation_function}${var.disk_throttled_bps_transformation_function}
    signal = ((A+B) / (C+D)).scale(100).publish('signal')
    detect(when(signal > ${var.disk_throttled_bps_threshold_critical})).publish('CRIT')
    detect(when(signal > ${var.disk_throttled_bps_threshold_warning}) and when(signal <= ${var.disk_throttled_bps_threshold_critical})).publish('WARN')
EOF

  rule {
    description           = "is too high > ${var.disk_throttled_bps_threshold_critical}"
    severity              = "Critical"
    detect_label          = "CRIT"
    disabled              = coalesce(var.disk_throttled_bps_disabled_critical, var.disk_throttled_bps_disabled, var.detectors_disabled)
    notifications         = coalescelist(var.disk_throttled_bps_notifications_critical, var.disk_throttled_bps_notifications, var.notifications)
    parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{readableRule}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
  }

  rule {
    description           = "is too high > ${var.disk_throttled_bps_threshold_warning}"
    severity              = "Warning"
    detect_label          = "WARN"
    disabled              = coalesce(var.disk_throttled_bps_disabled_warning, var.disk_throttled_bps_disabled, var.detectors_disabled)
    notifications         = coalescelist(var.disk_throttled_bps_notifications_warning, var.disk_throttled_bps_notifications, var.notifications)
    parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{readableRule}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
  }
}

resource "signalfx_detector" "disk_throttled_ops" {
  name = "${join("", formatlist("[%s]", var.prefixes))}[${var.environment}] GCP GCE Instance disk throttled ops"

  program_text = <<-EOF
    A = data('instance/disk/throttled_read_ops_count', ${module.filter-tags.filter_custom})${var.disk_throttled_ops_aggregation_function}${var.disk_throttled_ops_transformation_function}
    B = data('instance/disk/throttled_write_ops_count', ${module.filter-tags.filter_custom})${var.disk_throttled_ops_aggregation_function}${var.disk_throttled_ops_transformation_function}
    C = data('instance/disk/read_ops_count', ${module.filter-tags.filter_custom})${var.disk_throttled_ops_aggregation_function}${var.disk_throttled_ops_transformation_function}
    D = data('instance/disk/write_ops_count', ${module.filter-tags.filter_custom})${var.disk_throttled_ops_aggregation_function}${var.disk_throttled_ops_transformation_function}
    signal = ((A+B) / (C+D)).scale(100).publish('signal')
    detect(when(signal > ${var.disk_throttled_ops_threshold_critical})).publish('CRIT')
    detect(when(signal > ${var.disk_throttled_ops_threshold_warning}) and when(signal <= ${var.disk_throttled_ops_threshold_critical})).publish('WARN')
EOF

  rule {
    description           = "is too high > ${var.disk_throttled_ops_threshold_critical}"
    severity              = "Critical"
    detect_label          = "CRIT"
    disabled              = coalesce(var.disk_throttled_ops_disabled_critical, var.disk_throttled_ops_disabled, var.detectors_disabled)
    notifications         = coalescelist(var.disk_throttled_ops_notifications_critical, var.disk_throttled_ops_notifications, var.notifications)
    parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{readableRule}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
  }

  rule {
    description           = "is too high > ${var.disk_throttled_ops_threshold_warning}"
    severity              = "Warning"
    detect_label          = "WARN"
    disabled              = coalesce(var.disk_throttled_ops_disabled_warning, var.disk_throttled_ops_disabled, var.detectors_disabled)
    notifications         = coalescelist(var.disk_throttled_ops_notifications_warning, var.disk_throttled_ops_notifications, var.notifications)
    parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{readableRule}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
  }
}

