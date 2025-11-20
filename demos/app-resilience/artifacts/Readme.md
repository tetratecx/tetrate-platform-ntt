## What is this

### Prereq

- have access to all clusters
- have kubectl/kubectx installed
- have task installed

### To load demo config follow the steps

1. Switch context to `east-cluster` and deploy your app

```sh
kubectx east-cluster
kubectl apply -f app.yaml
```

2. Switch context to `west-cluster` and deploy your app

```sh
kubectx west-cluster
kubectl apply -f app.yaml
```

3. Switch context to `corp-edge` cluster to create certificate and secret

```sh
kubectx corp-edge
kubectl apply -f online-banking-cert.yaml
```

### To run demo follow the steps

1. Generate traffic to your app

```sh
task generate-traffic
```

2. Run this command to see available scenarios and execute them

```sh
task
```

### Acive/Active, Active/Standby setup examples

You can explicitly setup your A/A or A/S load balancing from Edge Gateway by following:

1. Run this commands for active/active:

```sh
kubectx east-cluster
kubectl patch service web-portal -n transaction-service -p ‘{“metadata”:{“annotations”:{“gateway.tetrate.io/edge-clusters”:“corp-edge:100"}}}’
kubectx west-cluster
kubectl patch service web-portal -n transaction-service -p ‘{“metadata”:{“annotations”:{“gateway.tetrate.io/edge-clusters”:“corp-edge:100"}}}’
```

2. Run this commands to make west-cluster as Active cluster expicitly

The Tetrate Platform automatically discovers all services and their geographic locations. By default, traffic is routed to the nearest local services. Clusters within the same region are prioritized first, and if they become unhealthy or unavailable, traffic will automatically fail over to the next available region.

```sh
kubectx east-cluster
kubectl patch service web-portal -n transaction-service -p ‘{“metadata”:{“annotations”:{“gateway.tetrate.io/edge-clusters”:“corp-edge:0"}}}’
kubectx west-cluster
kubectl patch service web-portal -n transaction-service -p ‘{“metadata”:{“annotations”:{“gateway.tetrate.io/edge-clusters”:“corp-edge:100"}}}’
```

While still generating traffic yuo can observe the topology view.