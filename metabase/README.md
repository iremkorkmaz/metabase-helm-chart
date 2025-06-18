# Metabase Helm Chart

This is a custom maintainable Helm chart for [Metabase](https://www.metabase.com/), the easy, open source way for everyone in your company to ask questions and learn from data.

**Current Metabase Version:** v0.55.4

## Features

- ✅ Easy version updates and maintenance
- ✅ Production-ready defaults
- ✅ Comprehensive configuration options
- ✅ Support for external databases (PostgreSQL, MySQL)
- ✅ SSL/TLS support
- ✅ Ingress configuration
- ✅ Horizontal Pod Autoscaling
- ✅ Pod Disruption Budget
- ✅ Service monitoring support

## Quick Start

### Prerequisites

- Kubernetes 1.19+
- Helm 3.0+

### Installation

1. **Clone this repository:**
   ```bash
   git clone <your-repository-url>
   cd metabase-helm-chart
   ```

2. **Install the chart:**
   ```bash
   helm install my-metabase ./metabase
   ```

3. **Access Metabase:**
   ```bash
   kubectl port-forward service/my-metabase 3000:80
   ```
   Then open http://localhost:3000 in your browser.

## Configuration

The following table lists the configurable parameters of the Metabase chart and their default values.

| Parameter | Description | Default |
|-----------|-------------|---------|
| **Deployment Configuration** |
| `replicaCount` | Desired number of controller pods | `1` |
| `deploymentAnnotations` | Extra deployment annotations | `{}` |
| `deploymentLabels` | Extra deployment labels | `{}` |
| `podAnnotations` | Controller pods annotations | `{}` |
| `podLabels` | Extra pods labels | `{}` |
| `podSecurityContext` | Security Context for the Metabase pod | `{}` |
| **Pod Disruption Budget** |
| `pdb.create` | Enable/disable a Pod Disruption Budget creation | `false` |
| `pdb.minAvailable` | Minimum number/percentage of pods that should remain scheduled | `1` |
| `pdb.maxUnavailable` | Maximum number/percentage of pods that may be made unavailable | `""` |
| **Horizontal Pod Autoscaling** |
| `hpa.enabled` | Enable Horizontal Pod Autoscaler | `false` |
| `hpa.minReplicas` | Minimum number of replicas | `1` |
| `hpa.maxReplicas` | Maximum number of replicas | `6` |
| `hpa.targetCPUUtilizationPercentage` | Target CPU utilization percentage | `80` |
| `hpa.targetMemoryUtilizationPercentage` | Target memory utilization percentage | `80` |
| **Image Configuration** |
| `image.repository` | Controller container image repository | `metabase/metabase` |
| `image.tag` | Controller container image tag | `v0.55.4` |
| `image.pullPolicy` | Controller container image pull policy | `IfNotPresent` |
| `image.pullSecrets` | Controller container image pull secrets | `[]` |
| **Network Configuration** |
| `listen.host` | Listening on a specific network host | `0.0.0.0` |
| `listen.port` | Listening on a specific network port | `3000` |
| **SSL Configuration** |
| `ssl.enabled` | Enable SSL to run over HTTPS | `false` |
| `ssl.port` | SSL port | `null` |
| `ssl.keyStore` | The key store in JKS format | `null` |
| `ssl.keyStorePassword` | The password for key Store | `null` |
| **Jetty Configuration** |
| `jetty.maxThreads` | Jetty max number of threads | `null` |
| `jetty.minThreads` | Jetty min number of threads | `null` |
| `jetty.maxQueued` | Jetty max queue size | `null` |
| `jetty.maxIdleTime` | Jetty max idle time | `null` |
| **Database Configuration** |
| `database.type` | Backend database type | `h2` |
| `database.host` | Database host | `null` |
| `database.port` | Database port | `null` |
| `database.file` | Database file (for H2; also add a volume to store it!) | `null` |
| `database.dbname` | Database name | `null` |
| `database.username` | Database username | `null` |
| `database.password` | Database password | `null` |
| `database.connectionURI` | Database connection URI (alternative to the above settings) | `null` |
| `database.existingSecret` | Existing secret for database credentials | `null` |
| `database.existingSecretUsernameKey` | Username key for existing secret | `null` |
| `database.existingSecretPasswordKey` | Password key for existing secret | `null` |
| `database.existingSecretConnectionURIKey` | ConnectionURI key for existing secret | `null` |
| `database.existingSecretEncryptionKeyKey` | EncryptionKey key for existing secret | `null` |
| **Password Configuration** |
| `password.complexity` | Complexity requirement for Metabase account's password | `normal` |
| `password.length` | Minimum length required for Metabase account's password | `6` |
| **Application Configuration** |
| `timeZone` | Service time zone | `UTC` |
| `emojiLogging` | Get a funny emoji in service log | `true` |
| `colorLogging` | Color log lines. When set to false it will disable log line colors | `true` |
| `javaOpts` | JVM options | `null` |
| `pluginsDirectory` | A directory with Metabase plugins | `null` |
| `siteUrl` | Base URL, useful for serving behind a reverse proxy | `null` |
| **Session Configuration** |
| `session.maxSessionAge` | Session expiration defined in minutes | `20160` |
| `session.sessionCookies` | When browser is closed, user login session will expire | `null` |
| **Health Checks** |
| `livenessProbe.path` | Liveness probe path | `/api/health` |
| `livenessProbe.initialDelaySeconds` | Delay before liveness probe is initiated | `120` |
| `livenessProbe.timeoutSeconds` | When the probe times out | `30` |
| `livenessProbe.failureThreshold` | Minimum consecutive failures for the probe | `6` |
| `readinessProbe.path` | Readiness probe path | `/api/health` |
| `readinessProbe.initialDelaySeconds` | Delay before readiness probe is initiated | `30` |
| `readinessProbe.timeoutSeconds` | When the probe times out | `3` |
| `readinessProbe.periodSeconds` | How often to perform the probe | `5` |
| **Service Configuration** |
| `service.name` | Service name | `metabase` |
| `service.type` | ClusterIP, NodePort, or LoadBalancer | `ClusterIP` |
| `service.externalPort` | Service external port | `80` |
| `service.internalPort` | Service internal port, should be the same as listen.port | `3000` |
| `service.nodePort` | Service node port | `null` |
| `service.annotations` | Service annotations | `{}` |
| `service.labels` | Service labels | `{}` |
| **Service Account** |
| `serviceAccount.create` | Specifies whether a service account should be created | `false` |
| `serviceAccount.annotations` | Annotations to add to the service account | `{}` |
| `serviceAccount.name` | The name of the service account to use | `""` |
| `serviceAccount.automountServiceAccountToken` | Automount API credentials for the service account | `false` |
| **Ingress Configuration** |
| `ingress.enabled` | Enable ingress controller resource | `false` |
| `ingress.className` | Ingress class name (Kubernetes 1.18+) | `""` |
| `ingress.hosts` | Ingress resource hostnames | `[{"host": "*", "paths": [{"path": "/", "pathType": "Prefix"}]}]` |
| `ingress.annotations` | Ingress annotations configuration | `{}` |
| `ingress.tls` | Ingress TLS configuration | `[]` |
| **Resources** |
| `resources` | Server resource requests and limits | `{}` |
| **Scheduling** |
| `nodeSelector` | Node labels for pod assignment | `{}` |
| `tolerations` | Toleration labels for pod assignment | `[]` |
| `affinity` | Affinity settings for pod assignment | `{}` |
| `topologySpreadConstraints` | Topology spread constraints for pod assignment | `[]` |
| **Security** |
| `securityContext` | Security Context for the Metabase container | `{}` |
| **Environment Variables** |
| `extraEnv` | Additional environment variables | `[]` |
| `envFrom` | Environment variables from ConfigMaps or Secrets | `[]` |
| **Volumes** |
| `extraVolumes` | Additional server volumes | `[]` |
| `extraVolumeMounts` | Additional server volumeMounts | `[]` |
| **Init Containers** |
| `extraInitContainers` | Additional init containers e.g. to download plugins | `[]` |
| **Sidecar Containers** |
| `sidecars` | Additional sidecar containers | `[]` |
| **Monitoring** |
| `monitoring.enabled` | Enable prometheus endpoint | `false` |
| `monitoring.port` | Listening port for prometheus endpoint | `9191` |
| `monitoring.serviceMonitor.enabled` | Enable ServiceMonitor resource for prometheus scraping | `false` |

## Maintaining and Updating Metabase

### Checking for New Versions

1. **Check the latest Metabase release:**
   ```bash
   curl -s "https://api.github.com/repos/metabase/metabase/releases/latest" | grep -o '"tag_name": "[^"]*' | cut -d'"' -f4
   ```

2. **Check Docker Hub for available tags:**
   ```bash
   curl -s "https://registry.hub.docker.com/v2/repositories/metabase/metabase/tags?page_size=10" | jq -r '.results[].name' | head -10
   ```

### Updating to a New Version

1. **Update the Chart.yaml:**
   - Edit `Chart.yaml`
   - Update `appVersion` to the new Metabase version
   - Increment `version` (chart version)

2. **Update values.yaml:**
   - Edit `values.yaml`
   - Update `image.tag` to the new Metabase version

3. **Test the update:**
   ```bash
   helm upgrade --dry-run my-metabase ./metabase
   ```

4. **Apply the update:**
   ```bash
   helm upgrade my-metabase ./metabase
   ```

### Automated Version Updates

For automated version checking, you can use this script:

```bash
#!/bin/bash
# update-metabase.sh

CURRENT_VERSION=$(grep 'appVersion:' Chart.yaml | cut -d'"' -f2)
LATEST_VERSION=$(curl -s "https://api.github.com/repos/metabase/metabase/releases/latest" | grep -o '"tag_name": "[^"]*' | cut -d'"' -f4)

echo "Current version: $CURRENT_VERSION"
echo "Latest version: $LATEST_VERSION"

if [ "$CURRENT_VERSION" != "$LATEST_VERSION" ]; then
    echo "Update available!"
    echo "Update Chart.yaml and values.yaml with version: $LATEST_VERSION"
else
    echo "Already up to date!"
fi
```

## Production Deployment

### Using External Database

For production, it's recommended to use an external database:

```yaml
database:
  type: postgres
  host: "postgres.example.com"
  port: "5432"
  dbname: "metabase"
  username: "metabase_user"
  password: "your-secure-password"
  # Or use existing secret:
  # existingSecret: "metabase-db-secret"
  # existingSecretUsernameKey: "username"
  # existingSecretPasswordKey: "password"
```

### Setting up Ingress

```yaml
ingress:
  enabled: true
  className: "nginx"
  hosts:
    - host: "metabase.yourdomain.com"
      paths:
        - path: /
          pathType: Prefix
  tls:
    - secretName: metabase-tls
      hosts:
        - metabase.yourdomain.com
```

### Resource Management

```yaml
resources:
  limits:
    cpu: 1000m
    memory: 2Gi
  requests:
    cpu: 500m
    memory: 1Gi
```

### Horizontal Pod Autoscaling

```yaml
hpa:
  enabled: true
  minReplicas: 2
  maxReplicas: 6
  targetCPUUtilizationPercentage: 70
  targetMemoryUtilizationPercentage: 80
```

## Monitoring

Enable monitoring with Prometheus:

```yaml
monitoring:
  enabled: true
  serviceMonitor:
    enabled: true
```

## Backup and Recovery

For production deployments, ensure you have proper backup strategies:

1. **Database backups** (if using external database)
2. **Application data backups** (if using H2 with persistent storage)
3. **Configuration backups**

## Troubleshooting

### Common Issues

1. **Pod won't start:** Check resource limits and database connectivity
2. **Database connection issues:** Verify database credentials and network policies
3. **Ingress not working:** Check ingress controller and DNS configuration

### Debugging Commands

```bash
# Check pod status
kubectl get pods -l app.kubernetes.io/name=metabase

# Check pod logs
kubectl logs -l app.kubernetes.io/name=metabase

# Check service endpoints
kubectl get endpoints

# Test database connectivity
kubectl exec -it <metabase-pod> -- nc -zv <database-host> <database-port>
```

## Contributing

1. Fork this repository
2. Create your feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This chart is licensed under the Apache License 2.0.

## Acknowledgments

This chart is based on the original Metabase Helm chart by [pmint93](https://github.com/pmint93/helm-charts) with improvements for maintainability and latest version support.

## Support

For Metabase-specific issues, refer to the [official Metabase documentation](https://www.metabase.com/docs/).
For chart-specific issues, please open an issue in this repository. 