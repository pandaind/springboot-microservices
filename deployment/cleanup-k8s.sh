#!/bin/bash

echo "🧹 Cleaning up E-commerce Microservices from Kubernetes..."

# Delete the microservices namespace (this removes all resources in it)
echo "🗑️  Deleting microservices namespace..."
./k8s-setup.sh delete-ns microservices

echo "✅ Cleanup complete!"
echo ""
echo "💡 To stop the entire cluster: ./k8s-setup.sh stop"
echo "💥 To delete the cluster:     ./k8s-setup.sh delete"
