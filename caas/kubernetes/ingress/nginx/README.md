## Notes

These detectors use prometheus metrics from ingress controller only available for version `=> 0.16`.

Enable the following flags in the Nginx Ingress Controller chart:
- `controller.stats.enabled=true`
- `controller.metrics.enabled=true`

And the following SignalFx agent configuration for each ingress controller:

```
monitors:
  - type: prometheus-exporter
    discoveryRule: container_image =~ "nginx-ingress-controller"
    port: 10254
    datapointsToExclude:
      - metricNames:
        - '*'
        - '!nginx_ingress_controller_requests'
        - '!nginx_ingress_controller_ingress_upstream_latency_seconds'
        - '!nginx_ingress_controller_request_duration_seconds'
        - '!nginx_ingress_controller_nginx_process_cpu_seconds_total'
        - '!nginx_ingress_controller_nginx_process_virtual_memory_bytes'
        - '!nginx_ingress_controller_nginx_process_resident_memory_bytes'
```

__Note__: This whielisting type of metrics filtering is highly recommended
while prometheus exporters often send lot of metrics where not all useful.
And `prometheus-exporter` SignalFx monitor consider every metrics as custom,
so this could have a significant impact on billing.
