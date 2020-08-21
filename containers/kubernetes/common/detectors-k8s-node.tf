resource "signalfx_detector" "heartbeat" {
  name = "${join("", formatlist("[%s]", var.prefixes))}[${var.environment}] Kubernetes node heartbeat"

  program_text = <<-EOF
    from signalfx.detectors.not_reporting import not_reporting
    signal = data('kubernetes.container_ready', filter=(not filter('aws_state', '{Code: 32,Name: shutting-down', '{Code: 48,Name: terminated}', '{Code: 62,Name: stopping}', '{Code: 80,Name: stopped}')) and (not filter('gcp_status', '{Code=3, Name=STOPPING}', '{Code=4, Name=TERMINATED}')) and (not filter('azure_power_state', 'PowerState/stopping', 'PowerState/stoppped', 'PowerState/deallocating', 'PowerState/deallocated')) and ${module.filter-tags.filter_custom}).publish('signal')
    not_reporting.detector(stream=signal, resource_identifier=['kubernetes_node'], duration='${var.heartbeat_timeframe}').publish('CRIT')
EOF

  rule {
    description           = "has not reported in ${var.heartbeat_timeframe}"
    severity              = "Critical"
    detect_label          = "CRIT"
    disabled              = coalesce(var.heartbeat_disabled, var.detectors_disabled)
    notifications         = coalescelist(var.heartbeat_notifications, var.notifications)
    parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{ruleName}}} on {{{dimensions}}}"
  }
}

resource "signalfx_detector" "ready" {
  name = "${join("", formatlist("[%s]", var.prefixes))}[${var.environment}] Kubernetes node status"

  program_text = <<-EOF
    signal = data('kubernetes.node_ready', filter=(not filter('aws_state', '{Code: 32,Name: shutting-down', '{Code: 48,Name: terminated}', '{Code: 62,Name: stopping}', '{Code: 80,Name: stopped}')) and (not filter('gcp_status', '{Code=3, Name=STOPPING}', '{Code=4, Name=TERMINATED}')) and (not filter('azure_power_state', 'PowerState/stopping', 'PowerState/stoppped', 'PowerState/deallocating', 'PowerState/deallocated')) and ${module.filter-tags.filter_custom})${var.ready_aggregation_function}.publish('signal')
    detect(when(signal == ${var.ready_threshold_critical}, lasting='${var.ready_timer}')).publish('CRIT')
EOF

  rule {
    description           = "is not ready"
    severity              = "Critical"
    detect_label          = "CRIT"
    disabled              = coalesce(var.ready_disabled, var.detectors_disabled)
    notifications         = coalescelist(var.ready_notifications, var.notifications)
    parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{readableRule}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
  }
}

resource "signalfx_detector" "volume_space" {
  name = "${join("", formatlist("[%s]", var.prefixes))}[${var.environment}] Kubernetes node volume space usage"

  program_text = <<-EOF
    A = data('kubernetes.volume_available_bytes', ${module.filter-tags.filter_custom} and not filter('volume_type', 'configMap', 'secret'))${var.volume_space_aggregation_function}
    B = data('kubernetes.volume_capacity_bytes', ${module.filter-tags.filter_custom} and not filter('volume_type', 'configMap', 'secret'))${var.volume_space_aggregation_function}
    signal = ((B-A)/B).scale(100).${var.volume_space_transformation_function}(over='${var.volume_space_transformation_window}').publish('signal')
    detect(when(signal > ${var.volume_space_threshold_critical})).publish('CRIT')
    detect(when(signal > ${var.volume_space_threshold_warning}) and when(signal < ${var.volume_space_threshold_critical})).publish('WARN')
EOF

  rule {
    description           = "is too high > ${var.volume_space_threshold_critical}"
    severity              = "Critical"
    detect_label          = "CRIT"
    disabled              = coalesce(var.volume_space_disabled_critical, var.volume_space_disabled, var.detectors_disabled)
    notifications         = coalescelist(var.volume_space_notifications_critical, var.volume_space_notifications, var.notifications)
    parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{readableRule}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
  }

  rule {
    description           = "is too high > ${var.volume_space_threshold_warning}"
    severity              = "Warning"
    detect_label          = "WARN"
    disabled              = coalesce(var.volume_space_disabled_warning, var.volume_space_disabled, var.detectors_disabled)
    notifications         = coalescelist(var.volume_space_notifications_warning, var.volume_space_notifications, var.notifications)
    parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{readableRule}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
  }
}

resource "signalfx_detector" "volume_inodes" {
  name = "${join("", formatlist("[%s]", var.prefixes))}[${var.environment}] Kubernetes node volume inodes usage"

  program_text = <<-EOF
    A = data('kubernetes.volume_inodes_free', ${module.filter-tags.filter_custom} and not filter('volume_type', 'configMap', 'secret'))${var.volume_inodes_aggregation_function}
    B = data('kubernetes.volume_inodes', ${module.filter-tags.filter_custom} and not filter('volume_type', 'configMap', 'secret'))${var.volume_inodes_aggregation_function}
    signal = ((B-A)/B).scale(100).${var.volume_inodes_transformation_function}(over='${var.volume_inodes_transformation_window}').publish('signal')
    detect(when(signal > ${var.volume_inodes_threshold_critical})).publish('CRIT')
    detect(when(signal > ${var.volume_inodes_threshold_warning}) and when(signal < ${var.volume_inodes_threshold_critical})).publish('WARN')
EOF

  rule {
    description           = "is too high > ${var.volume_inodes_threshold_critical}"
    severity              = "Critical"
    detect_label          = "CRIT"
    disabled              = coalesce(var.volume_inodes_disabled_critical, var.volume_inodes_disabled, var.detectors_disabled)
    notifications         = coalescelist(var.volume_inodes_notifications_critical, var.volume_inodes_notifications, var.notifications)
    parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{readableRule}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
  }

  rule {
    description           = "is too high > ${var.volume_inodes_threshold_warning}"
    severity              = "Warning"
    detect_label          = "WARN"
    disabled              = coalesce(var.volume_inodes_disabled_warning, var.volume_inodes_disabled, var.detectors_disabled)
    notifications         = coalescelist(var.volume_inodes_notifications_warning, var.volume_inodes_notifications, var.notifications)
    parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{readableRule}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
  }
}

resource "signalfx_detector" "pod_phase_status" {
  name = "${join("", formatlist("[%s]", var.prefixes))}[${var.environment}] Kubernetes pod status phase: failed"

  program_text = <<-EOF
    from signalfx.detectors.aperiodic import conditions
    # Current phase of the pod (1 - Pending, 2 - Running, 3 - Succeeded, 4 - Failed, 5 - Unknown)
    signal = data('kubernetes.pod_phase', filter=${module.filter-tags.filter_custom})${var.pod_phase_status_aggregation_function}.${var.pod_phase_status_transformation_function}(over='${var.pod_phase_status_transformation_window}').publish('signal')
    ON_Condition_CRIT = conditions.generic_condition(signal, 4, 5, 'within_range', lasting('${var.pod_phase_status_aperiodic_duration}', ${var.pod_phase_status_aperiodic_percentage}), 'observed', strict_1=False, strict_2=False)
    detect(ON_Condition_CRIT, off=when(signal is None, '${var.pod_phase_status_clear_duration}')).publish('CRIT')
EOF

  rule {
    description           = "for too long (${var.pod_phase_status_transformation_window} + ${var.pod_phase_status_aperiodic_duration})"
    severity              = "Critical"
    detect_label          = "CRIT"
    disabled              = coalesce(var.pod_phase_status_disabled_critical, var.pod_phase_status_disabled, var.detectors_disabled)
    notifications         = coalescelist(var.pod_phase_status_notifications_critical, var.pod_phase_status_notifications, var.notifications)
    parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{readableRule}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
  }
}

resource "signalfx_detector" "error" {
  name = "${join("", formatlist("[%s]", var.prefixes))}[${var.environment}] Kubernetes pod waiting errors"

  program_text = <<-EOF
    signal = data('kubernetes.container_ready', filter=filter('container_status', 'waiting') and ${module.filter-tags.filter_custom})${var.error_aggregation_function}.${var.error_transformation_function}(over='${var.error_transformation_window}').publish('signal')
    detect(when(signal > ${var.error_threshold_critical})).publish('CRIT')
    detect(when(signal > ${var.error_threshold_warning}) and when(signal <= ${var.error_threshold_critical})).publish('WARN')
EOF

  rule {
    description           = "is too high > ${var.error_threshold_critical}"
    severity              = "Critical"
    detect_label          = "CRIT"
    disabled              = coalesce(var.error_disabled_critical, var.error_disabled, var.detectors_disabled)
    notifications         = coalescelist(var.error_notifications_critical, var.error_notifications, var.notifications)
    parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{readableRule}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
  }

  rule {
    description           = "is too high > ${var.error_threshold_warning}"
    severity              = "Warning"
    detect_label          = "WARN"
    disabled              = coalesce(var.error_disabled_warning, var.error_disabled, var.detectors_disabled)
    notifications         = coalescelist(var.error_notifications_warning, var.error_notifications, var.notifications)
    parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{readableRule}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
  }
}

resource "signalfx_detector" "terminated" {
  name = "${join("", formatlist("[%s]", var.prefixes))}[${var.environment}] Kubernetes pod terminated abnormally"

  program_text = <<-EOF
    signal = data('kubernetes.container_ready', filter=filter('container_status', 'terminated') and not filter('container_status_reason', 'Completed') and ${module.filter-tags.filter_custom})${var.terminated_aggregation_function}.${var.terminated_transformation_function}(over='${var.terminated_transformation_window}').publish('signal')
    detect(when(signal > ${var.terminated_threshold_critical})).publish('CRIT')
    detect(when(signal > ${var.terminated_threshold_warning}) and when(signal <= ${var.terminated_threshold_critical})).publish('WARN')
EOF

  rule {
    description           = "is too high > ${var.terminated_threshold_critical}"
    severity              = "Critical"
    detect_label          = "CRIT"
    disabled              = coalesce(var.terminated_disabled_critical, var.terminated_disabled, var.detectors_disabled)
    notifications         = coalescelist(var.terminated_notifications_critical, var.terminated_notifications, var.notifications)
    parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{readableRule}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
  }

  rule {
    description           = "is too high > ${var.terminated_threshold_warning}"
    severity              = "Warning"
    detect_label          = "WARN"
    disabled              = coalesce(var.terminated_disabled_warning, var.terminated_disabled, var.detectors_disabled)
    notifications         = coalescelist(var.terminated_notifications_warning, var.terminated_notifications, var.notifications)
    parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{readableRule}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
  }
}

resource "signalfx_detector" "replica_available" {
  name = "${join("", formatlist("[%s]", var.prefixes))}[${var.environment}] Kubernetes workload available replicas"

  program_text = <<-EOF
    A = data('kubernetes.deployment.desired', ${module.filter-tags.filter_custom})${var.replica_available_aggregation_function}
    B = data('kubernetes.deployment.available', ${module.filter-tags.filter_custom})${var.replica_available_aggregation_function}
    signal = (A-B).${var.replica_available_transformation_function}(over='${var.replica_available_transformation_window}').publish('signal')
    detect(when(signal < ${var.replica_available_threshold_critical}) and when(B < ${var.replica_available_threshold_number_requests})).publish('CRIT')
    detect(when(signal < ${var.replica_available_threshold_warning}) and when(B < ${var.replica_available_threshold_number_requests}) and when(signal >= ${var.replica_available_threshold_critical})).publish('WARN')

EOF

  rule {
    description           = "are too low < ${var.replica_available_threshold_critical}"
    severity              = "Critical"
    detect_label          = "CRIT"
    disabled              = coalesce(var.replica_available_disabled_critical, var.replica_available_disabled, var.detectors_disabled)
    notifications         = coalescelist(var.replica_available_notifications_critical, var.replica_available_notifications, var.notifications)
    parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{readableRule}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
  }

  rule {
    description           = "are too low < ${var.replica_available_threshold_warning}"
    severity              = "Warning"
    detect_label          = "WARN"
    disabled              = coalesce(var.replica_available_disabled_warning, var.replica_available_disabled, var.detectors_disabled)
    notifications         = coalescelist(var.replica_available_notifications_warning, var.replica_available_notifications, var.notifications)
    parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{readableRule}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
  }
}

resource "signalfx_detector" "replica_ready" {
  name = "${join("", formatlist("[%s]", var.prefixes))}[${var.environment}] Kubernetes workload ready replicas"

  program_text = <<-EOF
    A = data('kubernetes.replica_set.desired', ${module.filter-tags.filter_custom})${var.replica_ready_aggregation_function}
    B = data('kubernetes.replica_set.available', ${module.filter-tags.filter_custom})${var.replica_ready_aggregation_function}
    signal = (A-B).${var.replica_ready_transformation_function}(over='${var.replica_ready_transformation_window}').publish('signal')
    detect(when(signal < ${var.replica_ready_threshold_critical}) and when(B < ${var.replica_ready_threshold_number_requests})).publish('CRIT')
    detect(when(signal < ${var.replica_ready_threshold_warning}) and when(B < ${var.replica_ready_threshold_number_requests}) and when(signal >= ${var.replica_ready_threshold_critical})).publish('WARN')

EOF

  rule {
    description           = "are too low < ${var.replica_ready_threshold_critical}"
    severity              = "Critical"
    detect_label          = "CRIT"
    disabled              = coalesce(var.replica_ready_disabled_critical, var.replica_ready_disabled, var.detectors_disabled)
    notifications         = coalescelist(var.replica_ready_notifications_critical, var.replica_ready_notifications, var.notifications)
    parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{readableRule}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
  }

  rule {
    description           = "are too low < ${var.replica_ready_threshold_warning}"
    severity              = "Warning"
    detect_label          = "WARN"
    disabled              = coalesce(var.replica_ready_disabled_warning, var.replica_ready_disabled, var.detectors_disabled)
    notifications         = coalescelist(var.replica_ready_notifications_warning, var.replica_ready_notifications, var.notifications)
    parameterized_subject = "[{{ruleSeverity}}]{{{detectorName}}} {{{readableRule}}} ({{inputs.signal.value}}) on {{{dimensions}}}"
  }
}

