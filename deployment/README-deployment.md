# Kubernetes Local Deployment Guide

This guide explains how to deploy the Spring Boot microservices to a local Kubernetes cluster using the provided setup scripts.

## Quick Start

### 1. Setup Local Kubernetes Cluster
```bash
# Install prerequisites (kubectl, minikube, helm)
./k8s-setup.sh install

# Start local cluster
./k8s-setup.sh start
```

### 2. Build and Deploy Services
```bash
# Build all Docker images
./build-images.sh

# Deploy to Kubernetes
./deploy-k8s.sh
```

### 3. Access Services
```bash
# Gateway (main entry point)
kubectl port-forward -n microservices svc/gateway 8080:8080

# Eureka Dashboard  
kubectl port-forward -n microservices svc/discovery 8761:8761

# Zipkin Tracing
kubectl port-forward -n microservices svc/zipkin 9411:9411
```

## Services Overview

| Service | Port | Description |
|---------|------|-------------|
| Gateway | 8080 | API Gateway and main entry point |
| Discovery | 8761 | Eureka service registry |
| Config Server | 8888 | Configuration management |
| Customer | 8090 | Customer management |
| Product | 8050 | Product catalog |
| Order | 8070 | Order processing |
| Payment | 8060 | Payment processing |
| Notification | 8040 | Email notifications |

## K8s Management Commands

The `k8s-setup.sh` script provides comprehensive cluster management:

```bash
# Cluster operations
./k8s-setup.sh start          # Start cluster
./k8s-setup.sh stop           # Stop cluster  
./k8s-setup.sh restart        # Restart cluster
./k8s-setup.sh status         # Show detailed status
./k8s-setup.sh delete         # Delete cluster

# Namespace management
./k8s-setup.sh create-ns <name>    # Create namespace
./k8s-setup.sh delete-ns <name>    # Delete namespace

# Application management
./k8s-setup.sh deploy <yaml-file>  # Deploy from YAML
./k8s-setup.sh get-all             # Show all resources
./k8s-setup.sh scale <deployment> <replicas> [namespace]

# Debugging utilities
./k8s-setup.sh logs <pod-name> [namespace] [follow]
./k8s-setup.sh exec <pod-name> [namespace] [command]
./k8s-setup.sh port-forward <service> <local:service-port> [namespace]

# Dashboard and monitoring
./k8s-setup.sh enable-dashboard    # Enable K8s dashboard
./k8s-setup.sh dashboard           # Open dashboard
```

## Monitoring and Health Checks

### Check Deployment Status
```bash
# Overview
./k8s-setup.sh status

# Detailed pod status
kubectl get pods -n microservices -o wide

# Service endpoints
kubectl get services -n microservices
```

### View Logs
```bash
# All pods in namespace
kubectl logs -n microservices -l app=gateway --tail=100

# Specific service
./k8s-setup.sh logs gateway microservices follow
```

### Health Endpoints
Access health checks via port-forwarding:
- Gateway: `http://localhost:8080/actuator/health`
- Discovery: `http://localhost:8761/actuator/health`

## Troubleshooting

### Common Issues

1. **Pods not starting**
   ```bash
   kubectl describe pods -n microservices
   ./k8s-setup.sh logs <pod-name> microservices
   ```

2. **Service connectivity issues**
   ```bash
   kubectl get endpoints -n microservices
   kubectl exec -n microservices deployment/gateway -- nslookup discovery
   ```

3. **Resource constraints**
   ```bash
   kubectl top nodes
   kubectl top pods -n microservices
   ```

### Reset Environment
```bash
# Clean slate
./k8s-setup.sh delete
./k8s-setup.sh start
./deploy-k8s.sh
```

## Docker Compose Alternative

For simpler local development, use Docker Compose instead:

```bash
# Start infrastructure only
docker-compose -f docker-compose.infra.yml up -d

# Start all services
docker-compose -f docker-compose.services.yml up -d
```