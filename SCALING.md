# AllStar Service Scaling

### Traditional Autoscaling (HPA)

The chart supports traditional CPU and memory-based autoscaling:

```yaml
autoscaling:
  enabled: true
  replicas:
    min: 2
    max: 10
  averageUtilization:
    cpu: 80
    memory: 80
```

### KEDA NATS JetStream Autoscaling

For event-driven autoscaling based on NATS JetStream message lag:

```yaml
autoscaling:
  enabled: false # Disable traditional HPA when using KEDA
  keda:
    enabled: true
    natsJetstream:
      enabled: true
      natsServerMonitoringEndpoint: "nats.nats.svc.cluster.local:8222"
      account: "$G"
      stream: "mystream"
      consumer: "pull_consumer"
      lagThreshold: "10"
      activationLagThreshold: "15"
      useHttps: false
      authentication:
        enabled: true
        triggerAuthenticationName: "my-nats-auth"
```

## NATS JetStream Authentication

### Using Existing NATS Credentials

If your pods already have NATS credentials via external secrets, KEDA can use the same credentials:

```yaml
autoscaling:
  keda:
    natsJetstream:
      authentication:
        enabled: true
```

This configuration tells KEDA to use the existing `{{ .Release.Name }}` secret with the `nats-credentials` key that your application already uses. The TriggerAuthentication will be automatically named `{{ .Release.Name }}-scaler-auth`.

## Parameters

| Parameter                           | Description                  | Default           |
| ----------------------------------- | ---------------------------- | ----------------- |
| `autoscaling.keda.enabled`          | Enable KEDA autoscaling      | `false`           |
| `autoscaling.keda.namespace`        | Namespace for KEDA resources | Release namespace |
| `autoscaling.keda.triggers`         | Array of KEDA triggers       | `[]`              |
| `autoscaling.keda.triggers[*].type` | Trigger type                 | Required          |

**NATS JetStream Trigger Parameters:**
| Parameter | Description | Default |
| ---------------------------------- | --------------------------------- | ---------------------------------- |
| `type` | Must be `nats-jetstream` | Required |
| `natsServerUrl` | NATS server URL (from staticEnv) | `""` |
| `natsServerMonitoringEndpoint` | NATS monitoring endpoint | `nats.nats.svc.cluster.local:8222` |
| `account` | NATS account name | `$G` |
| `stream` | JetStream stream name | `mystream` |
| `consumer` | Consumer name | `pull_consumer` |
| `lagThreshold` | Message lag threshold for scaling | `10` |
| `activationLagThreshold` | Lag threshold to activate scaler | `15` |
| `useHttps` | Use HTTPS for NATS endpoint | `false` |
| `authentication.enabled` | Enable NATS authentication | `false` |

## Examples

### Basic KEDA NATS JetStream Setup

```yaml
autoscaling:
  keda:
    enabled: true
    triggers:
      - type: nats-jetstream
        # Use existing NATS_SERVERS from staticEnv
        natsServerUrl: "tls://aws.cloud.ngs.global"
        stream: "orders"
        consumer: "order-processor"
        lagThreshold: "5"
```

### Complete Example with Existing Credentials

```yaml
autoscaling:
  keda:
    enabled: true
    triggers:
      - type: nats-jetstream
        natsServerMonitoringEndpoint: "nats.example.com:8222"
        account: "PROD"
        stream: "orders"
        consumer: "order-processor"
        lagThreshold: "10"
        activationLagThreshold: "20"
        useHttps: true
        authentication:
          enabled: true
```

This uses the existing `orders-processor` secret with the `nats-credentials` key that your application already uses.

### Using Existing NATS Server Configuration

If your pods already have `NATS_SERVERS` configured in `staticEnv`, you can use the same URL:

```yaml
autoscaling:
  keda:
    enabled: true
    triggers:
      - type: nats-jetstream
        natsServerUrl: "tls://aws.cloud.ngs.global" # From your staticEnv
        # KEDA will derive monitoring endpoint: aws.cloud.ngs.global:8222
        account: "PROD"
        stream: "orders"
        consumer: "order-processor"
        lagThreshold: "10"
        authentication:
          enabled: true
```

### Multiple Triggers Example

You can combine multiple triggers for more complex scaling scenarios:

```yaml
autoscaling:
  keda:
    enabled: true
    triggers:
      - type: nats-jetstream
        natsServerUrl: "tls://aws.cloud.ngs.global"
        stream: "orders"
        consumer: "order-processor"
        lagThreshold: "10"
        authentication:
          enabled: true
      - type: cpu
        metadata:
          type: Utilization
          value: "80"
      - type: memory
        metadata:
          type: Utilization
          value: "80"
```

## Troubleshooting

1. **KEDA not scaling**: Check that KEDA is installed and running in your cluster
2. **NATS connection issues**: Verify the NATS server monitoring endpoint is accessible
3. **Authentication failures**: Ensure the existing secret contains valid NATS credentials
4. **No metrics available**: Check that JetStream is enabled on your NATS server
5. **Secret access issues**: Verify KEDA can access the secret in the same namespace

## Resources

- [KEDA Documentation](https://keda.sh/)
- [NATS JetStream Scaler](https://keda.sh/docs/2.17/scalers/nats-jetstream/)
- [NATS Documentation](https://docs.nats.io/)
