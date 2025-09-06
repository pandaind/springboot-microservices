# Kubernetes Deployment Guide

This guide provides step-by-step instructions for deploying the E-commerce microservices platform to a local Kubernetes cluster.

## Prerequisites

- Linux/macOS system
- Docker installed and running
- Internet connection for downloading tools

## Quick Start (3 Steps)

### 1. Setup Local Kubernetes Cluster
```bash
cd deployment
./k8s-setup.sh install    # Install kubectl, minikube, helm
./k8s-setup.sh start      # Start local cluster
```

### 2. Build and Deploy
```bash
./build-images.sh         # Build Docker images
./deploy-k8s.sh          # Deploy to Kubernetes
```

### 3. Access Services
```bash
# Gateway (main API endpoint)
kubectl port-forward -n microservices svc/gateway 8080:8080

# Open in browser: http://localhost:8080
```

## Detailed Setup Instructions

### Step 1: Install Kubernetes Tools
The `k8s-setup.sh` script will install:
- **kubectl** - Kubernetes command-line tool
- **minikube** - Local Kubernetes cluster
- **helm** - Package manager for Kubernetes

```bash
cd deployment
./k8s-setup.sh install
```

### Step 2: Start Local Cluster
```bash
./k8s-setup.sh start
```

This creates a local Kubernetes cluster with:
- 2 CPU cores
- 2GB RAM
- Docker driver

### Step 3: Verify Cluster
```bash
./k8s-setup.sh status
```

Expected output should show:
- ✅ Minikube running
- ✅ Nodes ready
- ✅ System pods running

### Step 4: Build Application Images
```bash
./build-images.sh
```

This builds Docker images for all microservices:
- config-server
- discovery
- gateway
- customer, product, order, payment, notification

### Step 5: Deploy to Kubernetes
```bash
./deploy-k8s.sh
```

The deployment process:
1. Creates `microservices` namespace
2. Deploys infrastructure (PostgreSQL, MongoDB, Kafka, Zipkin)
3. Deploys services in dependency order
4. Sets up service networking and ingress

### Step 6: Verify Deployment
```bash
# Check all pods are running
kubectl get pods -n microservices

# Check service endpoints
kubectl get services -n microservices

# View detailed status
./k8s-setup.sh get-all microservices
```

## Accessing Services

### Port Forwarding (Recommended)
```bash
# Gateway - Main API entry point
kubectl port-forward -n microservices svc/gateway 8080:8080

# Eureka Dashboard - Service registry
kubectl port-forward -n microservices svc/discovery 8761:8761

# Zipkin - Distributed tracing
kubectl port-forward -n microservices svc/zipkin 9411:9411

# Database UIs
kubectl port-forward -n microservices svc/pgadmin 5050:80
kubectl port-forward -n microservices svc/mongo-express 8081:8081
```

### Service URLs
| Service | URL | Description |
|---------|-----|-------------|
| Gateway | http://localhost:8080 | Main API entry point |
| Eureka | http://localhost:8761 | Service registry dashboard |
| Zipkin | http://localhost:9411 | Distributed tracing UI |
| PgAdmin | http://localhost:5050 | PostgreSQL admin |
| Mongo Express | http://localhost:8081 | MongoDB admin |

## API Testing

### Health Check
```bash
curl http://localhost:8080/actuator/health
```

### Sample API Calls
```bash
# List customers
curl http://localhost:8080/api/v1/customers

# List products
curl http://localhost:8080/api/v1/products

# Create customer
curl -X POST http://localhost:8080/api/v1/customers \
  -H "Content-Type: application/json" \
  -d '{"firstName":"John","lastName":"Doe","email":"john@example.com"}'
```

## Monitoring and Debugging

### View Logs
```bash
# All gateway logs
kubectl logs -n microservices deployment/gateway -f

# Using k8s-setup script
./k8s-setup.sh logs gateway microservices follow
```

### Execute Commands in Pods
```bash
# Connect to gateway pod
kubectl exec -n microservices deployment/gateway -it -- bash

# Using k8s-setup script
./k8s-setup.sh exec gateway microservices bash
```

### Scale Services
```bash
# Scale gateway to 3 replicas
kubectl scale deployment gateway --replicas=3 -n microservices

# Using k8s-setup script
./k8s-setup.sh scale gateway 3 microservices
```

## Troubleshooting

### Common Issues

1. **Pods stuck in Pending state**
   ```bash
   kubectl describe pods -n microservices
   # Check for resource constraints or image pull issues
   ```

2. **Services not accessible**
   ```bash
   kubectl get endpoints -n microservices
   # Verify service endpoints are populated
   ```

3. **Database connection issues**
   ```bash
   kubectl logs -n microservices deployment/order -f
   # Check for database connectivity errors
   ```

### Reset Environment
```bash
# Clean deployment
./cleanup-k8s.sh

# Restart cluster
./k8s-setup.sh restart

# Redeploy
./deploy-k8s.sh
```

### Complete Cleanup
```bash
# Remove all microservices
./cleanup-k8s.sh

# Stop cluster
./k8s-setup.sh stop

# Delete cluster completely
./k8s-setup.sh delete
```

## Performance Tuning

### Resource Limits
Edit deployment YAML files to adjust:
```yaml
resources:
  requests:
    memory: "512Mi"
    cpu: "250m"
  limits:
    memory: "1Gi"
    cpu: "500m"
```

### Horizontal Pod Autoscaling
```bash
# Enable metrics server (if not already)
minikube addons enable metrics-server

# Create HPA for gateway
kubectl autoscale deployment gateway --cpu-percent=70 --min=1 --max=5 -n microservices
```

## Advanced Configuration

### Custom Ingress
For production-like setup with custom domain:
```bash
# Add to /etc/hosts
echo "127.0.0.1 microservices.local" | sudo tee -a /etc/hosts

# Enable ingress addon
minikube addons enable ingress

# Access via domain
curl http://microservices.local/api/v1/customers
```

### Persistent Storage
For data persistence across cluster restarts, configure persistent volumes in the infrastructure deployment files.

## Next Steps

1. **Load Testing**: Use the Postman collection for API testing
2. **Monitoring**: Set up Prometheus and Grafana for metrics
3. **Security**: Implement HTTPS and authentication
4. **CI/CD**: Automate deployments with GitHub Actions

## Support

For issues or questions:
1. Check pod logs: `./k8s-setup.sh logs <service-name> microservices`
2. Verify cluster status: `./k8s-setup.sh status`
3. Review deployment events: `kubectl get events -n microservices`
