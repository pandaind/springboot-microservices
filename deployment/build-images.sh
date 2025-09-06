#!/bin/bash

echo "Building all microservice Docker images..."

# Build all microservices
services=("config-server" "discovery" "gateway" "customer" "order" "payment" "product" "notification")

for service in "${services[@]}"; do
    echo "Building $service..."
    cd "../$service"
    docker build -t "$service:latest" .
    if [ $? -eq 0 ]; then
        echo "✓ $service built successfully"
    else
        echo "✗ Failed to build $service"
        exit 1
    fi
    cd ../deployment
done

echo "All images built successfully!"