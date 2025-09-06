# E-Commerce Microservices with Spring Boot

A comprehensive e-commerce platform built using Spring Boot microservices architecture. This project demonstrates the implementation of a distributed system with multiple interconnected services handling different business domains.

## Architecture Overview

This project implements a microservices architecture with the following components:

### Infrastructure Services
- **Config Server** - Centralized configuration management
- **Discovery Service** - Service registry using Eureka
- **Gateway Service** - API Gateway for routing and load balancing

### Business Services
- **Customer Service** - Customer management and profiles
- **Product Service** - Product catalog and inventory management
- **Order Service** - Order processing and management
- **Payment Service** - Payment processing and transactions
- **Notification Service** - Email notifications for orders and payments

### Supporting Infrastructure
- **PostgreSQL** - Database for transactional data
- **MongoDB** - Database for notifications and customer data
- **Apache Kafka** - Event streaming for microservices communication
- **Zipkin** - Distributed tracing
- **MailDev** - Email testing in development

## Technology Stack

- **Java 17+**
- **Spring Boot 3.x**
- **Spring Cloud**
- **Spring Data JPA**
- **Spring Data MongoDB**
- **Apache Kafka**
- **PostgreSQL**
- **MongoDB**
- **Docker & Docker Compose**
- **Maven**

## Getting Started

### Prerequisites
- Java 17 or higher
- Maven 3.6+
- Docker and Docker Compose
- kubectl (for Kubernetes deployment)

### Running the Application

#### Option 1: Using Docker Compose (Recommended)

1. **Start Infrastructure Only**
   ```bash
   docker-compose -f docker-compose.infra.yml up -d
   ```

2. **Start Services Only** (after infrastructure is running)
   ```bash
   docker-compose -f docker-compose.services.yml up -d
   ```

3. **Start Everything Together**
   ```bash
   docker-compose -f docker-compose.infra.yml -f docker-compose.services.yml up -d
   # OR using the combined file
   docker-compose up -d
   ```

#### Option 2: Mixed (Infrastructure in Docker, Services Locally)

1. **Start Infrastructure Services**
   ```bash
   docker-compose -f docker-compose.infra.yml up -d
   ```

2. **Start Services Locally in Order**
   ```bash
   # 1. Config Server
   cd config-server && mvn spring-boot:run
   
   # 2. Discovery Service
   cd discovery && mvn spring-boot:run
   
   # 3. Gateway Service
   cd gateway && mvn spring-boot:run
   
   # 4. Business Services (can be started in parallel)
   cd customer && mvn spring-boot:run
   cd product && mvn spring-boot:run
   cd order && mvn spring-boot:run
   cd payment && mvn spring-boot:run
   cd notification && mvn spring-boot:run
   ```

#### Option 3: Using Kubernetes (Local Cluster)

1. **Setup Local Kubernetes Cluster**
   ```bash
   # Use the provided k8s setup script
   cd deployment
   ./k8s-setup.sh install    # Install prerequisites (kubectl, minikube, helm)
   ./k8s-setup.sh start      # Start local cluster
   ```

2. **Build and Deploy Services**
   ```bash
   # Build Docker images
   ./build-images.sh
   
   # Deploy to Kubernetes
   ./deploy-k8s.sh
   ```

3. **Access Services via Port Forwarding**
   ```bash
   # Gateway (main entry point)
   kubectl port-forward -n microservices svc/gateway 8080:8080
   
   # Eureka Dashboard
   kubectl port-forward -n microservices svc/discovery 8761:8761
   ```

4. **Monitor Deployment**
   ```bash
   ./k8s-setup.sh status     # Check cluster status
   kubectl get pods -n microservices  # Check pod status
   ```

### K8s Management Commands

The `k8s-setup.sh` script provides comprehensive cluster management:

```bash
# Cluster operations
./k8s-setup.sh start          # Start cluster
./k8s-setup.sh stop           # Stop cluster
./k8s-setup.sh restart        # Restart cluster
./k8s-setup.sh status         # Show status

# Application deployment
./k8s-setup.sh deploy k8s/    # Deploy from YAML files
./k8s-setup.sh get-all        # Show all resources

# Debugging
./k8s-setup.sh logs <pod-name>           # Get pod logs
./k8s-setup.sh exec <pod-name>           # Execute in pod
./k8s-setup.sh port-forward <svc> <port> # Port forward service
```

### Service Ports

| Service | Port |
|---------|------|
| Config Server | 8888 |
| Discovery Service | 8761 |
| Gateway Service | 8080 |
| Customer Service | 8090 |
| Product Service | 8050 |
| Order Service | 8070 |
| Payment Service | 8060 |
| Notification Service | 8040 |

### Infrastructure Ports

| Service | Port |
|---------|------|
| PostgreSQL | 5432 |
| PgAdmin | 5050 |
| MongoDB | 27017 |
| Mongo Express | 8081 |
| Kafka | 9092 |
| Zipkin | 9411 |
| MailDev | 1080 (Web), 1025 (SMTP) |

## API Documentation

The services expose RESTful APIs accessible through the Gateway at `http://localhost:8080`

### Sample API Endpoints

- **Customers**: `GET/POST/PUT/DELETE /api/v1/customers`
- **Products**: `GET/POST/PUT/DELETE /api/v1/products`
- **Orders**: `GET/POST /api/v1/orders`
- **Payments**: `POST /api/v1/payments`

## Event-Driven Architecture

The system uses Apache Kafka for asynchronous communication:

- **Order Events** → Notification Service (order confirmations)
- **Payment Events** → Notification Service (payment confirmations)

## Development

### Project Structure
```
├── config-server/           # Centralized configuration server (Spring Cloud Config)
├── customer/                # Customer management microservice
├── discovery/               # Eureka service registry
├── gateway/                 # API Gateway for routing and security
├── notification/            # Notification microservice (email, etc.)
├── order/                   # Order processing microservice
├── payment/                 # Payment processing microservice
├── product/                 # Product catalog and inventory microservice
├── deployment/              # Deployment scripts, Docker Compose, Kubernetes YAMLs
│   ├── build-images.sh
│   ├── cleanup-k8s.sh
│   ├── deploy-k8s.sh
│   ├── docker-compose.infra.yml
│   ├── docker-compose.services.yml
│   ├── k8s-setup.sh
│   └── k8s/
│       ├── ingress.yaml
│       ├── namespace.yaml
│       ├── configmaps/
│       ├── deployments/
│       └── services/
├── diagrams/                # Architecture and service diagrams
│   └── micro-services.drawio
├── postman/                 # Postman collections and environment files
│   ├── E-commerce-Environment.postman_environment.json
│   ├── E-commerce-Microservices.postman_collection.json
│   └── QUICK_START_FLOWS.md
├── KUBERNETES.md            # Kubernetes deployment guide
├── README.md                # Project documentation
└── TODO.md                  # Roadmap and future enhancements
```

### Database Migrations

The Product service includes Flyway migrations in `product/src/main/resources/db/migration/`

## Monitoring and Observability

- **Service Discovery**: Eureka Dashboard at `http://localhost:8761`
- **Distributed Tracing**: Zipkin at `http://localhost:9411`
- **Database Management**: 
  - PgAdmin at `http://localhost:5050`
  - Mongo Express at `http://localhost:8081`
- **Email Testing**: MailDev at `http://localhost:1080`

## Documentation

- **[Kubernetes Deployment Guide](KUBERNETES.md)** - Complete guide for local K8s deployment
- **[API Testing Guide](postman/QUICK_START_FLOWS.md)** - Postman collection usage
- **[Docker Deployment](deployment/README-deployment.md)** - Docker Compose and K8s deployment
- **[Enhancement Roadmap](TODO.md)** - Future improvements and security enhancements

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is for educational purposes demonstrating Spring Boot microservices architecture.
