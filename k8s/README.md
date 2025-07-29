# Kubernetes Deployment for Fleek Web Scraper

This directory contains Kubernetes manifests and Helm charts for deploying the Fleek Web Scraper application.

## Architecture

The application consists of the following components:

- **Web**: Django application serving the web interface (2 replicas)
- **Worker**: Celery workers for background task processing (2 replicas)
- **Redis**: Message broker for Celery tasks (1 replica)
- **Flower**: Celery monitoring dashboard (1 replica)

## Quick Start

### Prerequisites

- Kubernetes cluster (minikube, kind, or cloud provider)
- kubectl configured
- Docker for building images

### Option 1: Using Kustomize (Recommended)

1. Build the Docker image:
   ```bash
   docker build -t fleek-scraper:latest .
   ```

2. Deploy using the automated script:
   ```bash
   ./k8s/deploy.sh
   ```

3. Access the application:
   - Web: http://your-cluster/web-service
   - Flower: http://your-cluster/flower-service

### Option 2: Manual Deployment

1. Apply manifests manually:
   ```bash
   kubectl apply -k k8s/manifests/
   ```

2. Check deployment status:
   ```bash
   kubectl get pods -n fleek-scraper
   ```

### Option 3: Using Helm Chart

1. Install the application:
   ```bash
   helm install fleek-scraper k8s/helm/fleek-scraper/
   ```

2. Upgrade the application:
   ```bash
   helm upgrade fleek-scraper k8s/helm/fleek-scraper/
   ```

## Directory Structure

```
k8s/
├── manifests/           # Raw Kubernetes manifests
│   ├── namespace.yaml   # Application namespace
│   ├── configmap.yaml   # Environment configuration
│   ├── redis.yaml       # Redis deployment and service
│   ├── web.yaml         # Django web app
│   ├── worker.yaml      # Celery worker
│   ├── flower.yaml      # Flower monitoring
│   └── kustomization.yaml
├── helm/                # Helm chart
│   └── fleek-scraper/
│       ├── Chart.yaml
│       ├── values.yaml
│       └── templates/
├── deploy.sh           # Automated deployment script
├── cleanup.sh          # Cleanup script
└── README.md
```

## Configuration

### Environment Variables

The application uses a ConfigMap for shared configuration:

- `CELERY_BROKER_URL`: Redis connection URL
- `CELERY_RESULT_BACKEND`: Redis backend URL
- `REDIS_URL`: Redis URL for Django
- `DJANGO_SETTINGS_MODULE`: Django settings module

### Helm Values

Key configurable values in `values.yaml`:

```yaml
replicaCount:
  web: 2        # Number of web replicas
  worker: 2     # Number of worker replicas

service:
  web:
    type: LoadBalancer  # Service type
    port: 80           # External port

resources:
  web:
    limits:
      cpu: 500m
      memory: 512Mi
```

## Monitoring

### Health Checks

All deployments include:
- **Liveness probes**: Restart unhealthy containers
- **Readiness probes**: Control traffic routing

### Flower Dashboard

Access Celery monitoring at:
- URL: http://your-cluster/flower-service:5555
- Default auth: admin/password

## Scaling

### Manual Scaling

```bash
# Scale web pods
kubectl scale deployment web --replicas=3 -n fleek-scraper

# Scale worker pods
kubectl scale deployment worker --replicas=5 -n fleek-scraper
```

### Horizontal Pod Autoscaler (HPA)

```bash
# Enable HPA for web deployment
kubectl autoscale deployment web --cpu-percent=70 --min=2 --max=10 -n fleek-scraper
```

## Troubleshooting

### Common Commands

```bash
# Check pod status
kubectl get pods -n fleek-scraper

# View logs
kubectl logs -f deployment/web -n fleek-scraper
kubectl logs -f deployment/worker -n fleek-scraper

# Check services
kubectl get services -n fleek-scraper

# Port forward for local access
kubectl port-forward service/web-service 8000:80 -n fleek-scraper
kubectl port-forward service/flower-service 5555:5555 -n fleek-scraper
```

### Issues and Solutions

1. **Pods not starting**: Check resource limits and node capacity
2. **Service not accessible**: Verify service type and ingress configuration
3. **Worker tasks failing**: Check Redis connectivity and Celery configuration

## Cleanup

Remove all resources:

```bash
./k8s/cleanup.sh
```

Or manually:

```bash
kubectl delete -k k8s/manifests/
```

## Security Considerations

- Change default Flower authentication in production
- Use secrets for sensitive environment variables
- Configure network policies for pod-to-pod communication
- Enable RBAC and pod security policies

## Production Deployment

For production environments:

1. Use secrets instead of ConfigMaps for sensitive data
2. Configure ingress with TLS certificates
3. Set up persistent volumes for Redis data
4. Enable monitoring and logging (Prometheus, Grafana, ELK)
5. Configure backup and disaster recovery procedures 