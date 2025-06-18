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

### Image Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `image.repository` | Metabase image repository | `metabase/metabase` |
| `image.tag` | Metabase image tag | `v0.55.4` |
| `image.pullPolicy` | Image pull policy | `IfNotPresent` |

### Database Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `database.type` | Database type (h2/mysql/postgres) | `h2` |
| `database.host` | Database host | `""` |
| `database.port` | Database port | `""` |
| `database.dbname` | Database name | `""` |
| `database.username` | Database username | `""` |
| `database.password` | Database password | `""` |

### Service Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `service.type` | Service type | `ClusterIP` |
| `service.externalPort` | Service external port | `80` |
| `service.internalPort` | Service internal port | `3000` |

### Ingress Configuration

| Parameter | Description | Default |
|-----------|-------------|---------|
| `ingress.enabled` | Enable ingress | `false` |
| `ingress.className` | Ingress class name | `""` |
| `ingress.hosts` | Ingress hosts | `[{"host": "*", "paths": [{"path": "/", "pathType": "Prefix"}]}]` |

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