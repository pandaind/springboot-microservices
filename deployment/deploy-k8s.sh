#!/bin/bash

echo "🚀 Deploying E-commerce Microservices to Kubernetes..."

# Check if cluster is running
if ! ./k8s-setup.sh status >/dev/null 2>&1; then
    echo "❌ Kubernetes cluster is not running. Starting cluster..."
    ./k8s-setup.sh start
fi

# Create namespace if it doesn't exist
echo "📦 Creating microservices namespace..."
./k8s-setup.sh create-ns microservices || true

# Apply ConfigMaps
echo "⚙️  Applying ConfigMaps..."
./k8s-setup.sh deploy k8s/configmaps/

# Deploy infrastructure services first
echo "🗄️  Deploying infrastructure services..."
./k8s-setup.sh deploy k8s/deployments/infrastructure.yaml

echo "⏳ Waiting for infrastructure services to be ready..."
kubectl wait --for=condition=ready pod -l app=postgresql -n microservices --timeout=300s
kubectl wait --for=condition=ready pod -l app=mongodb -n microservices --timeout=300s
kubectl wait --for=condition=ready pod -l app=kafka -n microservices --timeout=300s

# Deploy microservices in dependency order
echo "🔧 Deploying config-server..."
./k8s-setup.sh deploy k8s/deployments/config-server.yaml
kubectl wait --for=condition=ready pod -l app=config-server -n microservices --timeout=300s

echo "🔍 Deploying discovery service..."
./k8s-setup.sh deploy k8s/deployments/discovery.yaml
kubectl wait --for=condition=ready pod -l app=discovery -n microservices --timeout=300s

echo "🌐 Deploying gateway..."
./k8s-setup.sh deploy k8s/deployments/gateway.yaml
kubectl wait --for=condition=ready pod -l app=gateway -n microservices --timeout=300s

echo "🏪 Deploying business microservices..."
./k8s-setup.sh deploy k8s/deployments/customer.yaml
./k8s-setup.sh deploy k8s/deployments/product.yaml
./k8s-setup.sh deploy k8s/deployments/order.yaml
./k8s-setup.sh deploy k8s/deployments/payment.yaml
./k8s-setup.sh deploy k8s/deployments/notification.yaml

# Apply services
echo "🔌 Creating services..."
./k8s-setup.sh deploy k8s/services/

# Apply ingress
echo "🔗 Setting up ingress..."
./k8s-setup.sh deploy k8s/ingress.yaml

echo ""
echo "✅ Deployment complete!"
echo ""
echo "📊 Checking deployment status..."
./k8s-setup.sh get-all microservices

echo ""
echo "🎯 Quick Access Commands:"
echo "  Gateway:     kubectl port-forward -n microservices svc/gateway 8080:8080"
echo "  Eureka:      kubectl port-forward -n microservices svc/discovery 8761:8761"
echo "  Zipkin:      kubectl port-forward -n microservices svc/zipkin 9411:9411"
echo ""
echo "💡 For detailed status: ./k8s-setup.sh status"
echo "🔍 For service logs:    ./k8s-setup.sh logs <service-name> microservices"