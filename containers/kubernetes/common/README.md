## Related documentation

The detectors in this module are based on metrics reported by the following monitors:
* [kubelet-stats](https://docs.signalfx.com/en/latest/integrations/agent/monitors/kubelet-stats.html)
* [kubernetes-cluster](https://docs.signalfx.com/en/latest/integrations/agent/monitors/kubernetes-cluster.html)

## Requirements

The following metrics must be emitted by the SignalFx agent:

- `kubernetes.job.failed`
- `kubernetes.stateful_set.ready`
- `kubernetes.stateful_set.desired`

Here is a sample configuration fragment for the SignalFx agent:

```
monitors:
- type: kubelet-stats
  kubeletAPI:
    authType: serviceAccount
  datapointsToExclude:
  - dimensions:
      container_image:
      - '*pause-amd64*'
      - 'k8s.gcr.io/pause*'
    metricNames:
      - '*'
      - '!*network*'

- type: kubernetes-cluster
  extraMetrics:
    - kubernetes.job.failed
    - kubernetes.stateful_set.ready
    - kubernetes.stateful_set.desired
```

