 ## Real-Time Analytics Dashboard Report

The main idea of this project is to build a real-time analytics dashboard that collects metrics from many servers, processes them, and displays updated results for engineers monitoring system performance. The system receives data from thousands of servers, each sending metrics such as CPU or memory usage. The goal is to design and test different communication and data ingestion patterns to see how each affects performance, latency, and scalability.

## 🎯 Chosen Scenario: HTTP/2 Streaming with SSE, Stateful In-Memory Aggregation, and MySQL

### **Why This Approach?**

We chose **Approach 4** (HTTP/2 + SSE + Stateful Aggregation) as the optimal solution for real-time analytics because:

#### **1. HTTP/2 Streaming Benefits**
- ✅ **Multiplexing**: Single connection handles 1000+ concurrent streams
- ✅ **Header Compression (HPACK)**: Reduces overhead by ~30-50%
- ✅ **Binary Framing**: Faster parsing than HTTP/1.1 text
- ✅ **Low Latency**: Direct streaming without polling
- ✅ **Efficient Resource Usage**: One connection per server instead of multiple

#### **2. Server-Sent Events (SSE) for Dashboard**
- ✅ **Real-Time Updates**: Push updates to dashboard clients instantly
- ✅ **HTTP/2 Compatible**: Works seamlessly with HTTP/2 streams
- ✅ **Simple Protocol**: Easier than WebSockets for one-way communication
- ✅ **Automatic Reconnection**: Built-in browser support
- ✅ **Efficient**: Server pushes only when data changes

#### **3. Stateful In-Memory Aggregation**
- ✅ **Ultra-Fast Reads**: In-memory access (~microseconds) vs database queries (~milliseconds)
- ✅ **Real-Time Metrics**: Instant aggregation updates
- ✅ **Low Database Load**: Batch writes instead of per-metric inserts
- ✅ **High Throughput**: Can handle 50,000+ metrics/sec
- ✅ **Reduced Latency**: Dashboard reads from memory, not database

#### **4. MySQL for Persistence**
- ✅ **Durability**: Data survives server restarts
- ✅ **Historical Analysis**: Query past metrics and trends
- ✅ **Batching**: Efficient bulk inserts (100 metrics per batch)
- ✅ **Scalability**: MySQL handles large datasets efficiently
- ✅ **Standard**: Widely used, well-understood technology

---

## 🛠️ Tech Stack

### **Backend**
- **Node.js** (v18+) - Runtime environment
- **HTTP/2** - Protocol for metrics ingestion (streaming)
- **Server-Sent Events (SSE)** - Protocol for dashboard updates
- **Sequelize ORM** - Database abstraction layer
- **MySQL 8.0** - Persistent storage

### **In-Memory Processing**
- **JavaScript Map** - Stateful aggregation store
- **Async Mutex** - Thread-safe operations
- **Batching System** - Efficient database writes

### **Infrastructure**
- **Docker** - Containerization
- **Docker Compose** - Multi-container orchestration

### **Development Tools**
- **Nodemon** - Auto-reload during development
- **mkcert** - SSL certificate generation

---

## 🚀 Setup Instructions

### **Prerequisites**
- Docker Desktop installed
- Docker Compose installed
- 4GB+ RAM available

### **Quick Start**

```bash
# 1. Clone the repository
git clone <repository-url>
cd Real-Time-Analytics-Dashboard

# 2. Start db, app server and h2load testing with Docker Compose
docker-compose up --remove-orphans -d db app1

docker-compose up h2load  

# That's it! The system will:
# - Start MySQL database on port 3306
# - Start Redis on port 6379
# - Run database migrations automatically
# - Start the HTTP/2 server on port 4002
```

**Note:** The first time may take a few minutes to download Docker images.

### **Stop Services**

```bash
# Press Ctrl+C or run:
docker-compose down
```
#to run load test by code js -load-tester-
npm run start4
npm run loadtester4
open the https//localhost:4002 to see the frontend


### **What Gets Started**
- ✅ **MySQL Database** on port `3306`
- ✅ **HTTP/2 Server** on port `4002`
- ✅ **Database tables** created automatically

### **Access Points**
- **Dashboard**: `https://localhost:4002/`
- **Health Check**: `https://localhost:4002/health`
- **Statistics**: `https://localhost:4002/api/stats`
- **Metrics Endpoint**: `POST https://localhost:4002/api/metrics/stream`
- **Dashboard SSE**: `GET https://localhost:4002/api/dashboard/stream`



## 🏗️ Brief Architecture Overview

### **Key Components**

1. **HTTP/2 Streaming Endpoint** (`/api/metrics/stream`)
   - Receives metrics from servers via HTTP/2 streams
   - Processes in real-time
   - Updates in-memory aggregations

2. **In-Memory Aggregation Service**
   - Maintains `Map<server_id:metric_name, Aggregation>`
   - Updates on every metric
   - Provides instant reads for dashboard

3. **Batch Buffer & Flush Service**
   - Buffers metrics in memory (batch size: 100)
   - Flushes to MySQL every 5 seconds
   - Thread-safe with mutex locks

4. **SSE Dashboard Endpoint** (`/api/dashboard/stream`)
   - Broadcasts aggregated metrics every second
   - Real-time updates to connected clients
   - Uses HTTP/2 streams for SSE

5. **MySQL Database**
   - Stores raw metrics (`MetricRaw` table)
   - Stores minute aggregations (`MetricMinuteAgg` table)
   - Provides historical data access

## **Load Balancer Integration for Scalability (HAProxy)**
Why Use HAProxy as the Load Balancer?
HAProxy is chosen for its high performance and ability to manage Stateful Session Persistence via sticky sessions, which is critical when using In-Memory Aggregation.

High Throughput: Handles extremely high traffic volumes with minimal overhead.

Stateful Session Persistence: Uses Cookie-based sticky sessions (SERVERID cookie) to ensure clients sending metrics are consistently routed to the same application instance, preventing data loss in the in-memory store.

HTTP/2 & SSE Support: Fully capable of handling the streaming HTTP/2 and SSE traffic efficiently.

Performance Offload: Handles connection management, optimising application server resources.

## Performance Results: Proxy vs. No Proxy
The benchmark highlights the dramatic performance improvement achieved by routing traffic through the proxy layer:
<img width="801" height="356" alt="image" src="https://github.com/user-attachments/assets/c2643aac-678f-4bb3-88d5-c333143644a2" />

Conclusion: The proxy enables the system to achieve massive throughput gains and minimal connection latency by optimising connection management and offloading tasks.

## To run the project with a proxy
### 1. Clone the repository
git clone <repository-url>

cd Real-Time-Analytics-Dashboard

### 2. Start db, app servers, haproxy, and H2Load testing with Docker Compose
docker-compose build

docker-compose up -d db app1 app2 app3 haproxy

docker-compose up h2load 


For more Details, this is my YouTube Video link: https://www.youtube.com/watch?v=SHUl8RtHpQM





