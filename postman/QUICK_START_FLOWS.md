# Quick Start - API Testing Guide

## 🚀 Getting Started with Postman

### Step 1: Setup Environment
1. **Import Collection**: `E-commerce-Microservices.postman_collection.json`
2. **Import Environment**: `E-commerce-Environment.postman_environment.json`
3. **Configure Variables**:
   - `gateway_url`: `http://localhost:8080`
   - Ensure all services are running

### Step 2: Verify System Health
```bash
# Quick health check
curl http://localhost:8080/api/v1/customers
curl http://localhost:8080/api/v1/products
```
✅ Both should return data (empty arrays are fine)

### Step 3: Run Complete Purchase Flow
🎯 **Recommended Starting Point**

1. Navigate to: `🧪 Test Flows & Business Scenarios` → `🛒 Complete Purchase Flow (Happy Path)`
2. Right-click → "Run folder"
3. Click "Run E-commerce..."
4. Monitor execution

**Expected Results:**
```
✅ 1. Create Customer - PASS
✅ 2. Create Product - PASS  
✅ 3. Create Order - PASS
✅ 4. Process Payment - PASS
✅ 5. Verify Order Details - PASS
✅ 6. Verify Order Lines - PASS
```

## 📋 Available Test Flows

### Core Business Flows
- **🛒 Complete Purchase Flow** - End-to-end customer purchase
- **🏪 Inventory Management Flow** - Product catalog management
- **👥 Multi-Customer Scenario** - Concurrent customer operations
- **🔄 Service Integration Flow** - Cross-service validation

### Performance Testing
- **⚡ Performance & Load Testing** - Response time validation
- **📊 Stress Testing** - High-volume scenarios

## 🎯 What Tests Validate

After successful execution:
- ✅ **Customer data** persisted in MongoDB
- ✅ **Product catalog** updated in PostgreSQL
- ✅ **Orders** properly linked customers to products
- ✅ **Payments** processed successfully
- ✅ **All microservices** responding via Gateway
- ✅ **Event notifications** triggered via Kafka

## 🔧 Troubleshooting

### Common Issues
- **503 Service Unavailable**: Check if all services are running
- **Connection refused**: Verify gateway is accessible at port 8080
- **Test failures**: Check service logs for specific errors

### Debug Commands
```bash
# Check service status
kubectl get pods -n microservices  # For K8s
docker-compose ps                   # For Docker

# View gateway logs
kubectl logs -n microservices deployment/gateway -f
```
