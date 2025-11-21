# Tetrate Platform Multi-Cluster Resiliency Demo

## Overview

This demo showcases how Tetrate Platform delivers intelligent failover across infrastructure, clusters, workloads, and gateways—eliminating downtime caused by failures that traditional load balancers can't detect.

### The Problem

Modern distributed systems face failures at every level:
- Infrastructure outages
- Cluster upgrades and failures
- Workload crashes
- Gateway issues

Traditional gateways and load balancers can't detect these failures in real-time, leading to:
- Service downtime
- Failed transactions
- Poor user experience
- Hours of firefighting for operations teams
- Missed SLAs

**Critical question:** What happens if one of your clusters goes down right now?

### The Solution

Tetrate Platform provides intelligent, automated failover at every layer of your infrastructure.

## Prerequisites

Ensure you have the following installed and configured:
- Access to all required Kubernetes clusters
- `kubectl` and `kubectx`
- [`task`](https://taskfile.dev) (task runner)

## Setup Instructions

### 1. Deploy Application to East Cluster
```sh
kubectx east-cluster
kubectl apply -f app.yaml
```

### 2. Deploy Application to West Cluster
```sh
kubectx west-cluster
kubectl apply -f app.yaml
```

### 3. Configure Edge Gateway

Switch to the `corp-edge` cluster and apply resilience configurations:
```sh
kubectx corp-edge
kubectl apply -f online-banking-secret.yaml
kubectl apply -f http-profile.yaml
kubectl apply -f tenant-settings.yaml
```

## Running the Demo

### Generate Traffic

Start continuous traffic generation to your application:
```sh
task generate-traffic
```

### Execute Demo Scenarios

View and run available demonstration scenarios:
```sh
task
```

## Load Balancing Configuration

### Active/Active Setup (Round-Robin)

Distribute traffic evenly across both clusters:
```sh
kubectx east-cluster
kubectl patch service web-portal -n transaction-service -p '{"metadata":{"annotations":{"gateway.tetrate.io/edge-clusters":"corp-edge:100"}}}'

kubectx west-cluster
kubectl patch service web-portal -n transaction-service -p '{"metadata":{"annotations":{"gateway.tetrate.io/edge-clusters":"corp-edge:100"}}}'
```

### Active/Standby Setup

Configure west-cluster as the active cluster with east-cluster as standby:
```sh
kubectx east-cluster
kubectl patch service web-portal -n transaction-service -p '{"metadata":{"annotations":{"gateway.tetrate.io/edge-clusters":"corp-edge:0"}}}'

kubectx west-cluster
kubectl patch service web-portal -n transaction-service -p '{"metadata":{"annotations":{"gateway.tetrate.io/edge-clusters":"corp-edge:100"}}}'
```

### How Automatic Failover Works

Tetrate Platform automatically discovers all services and their geographic locations. By default:
1. Traffic routes to the nearest local services
2. Clusters within the same region are prioritized
3. If local clusters become unhealthy or unavailable, traffic automatically fails over to the next available region

### Monitoring

While traffic is being generated, observe the topology view to see real-time routing and failover behavior.