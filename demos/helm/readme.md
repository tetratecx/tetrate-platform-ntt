## Ussage - default installation

### What will be installed

```mermaid
flowchart TB
    subgraph "Namespace: transaction-oversight (Istio Injected)"
        direction TB
        TG["Transaction Gateway\n(type: UNIFIED)"]
        
        TP["Transaction Portal\nDeployment (v2)"]
        AS["Account Service\nDeployment (v1)"]
        FD["Fraud Detection\nDeployment (v2)"]
        RA["Risk Assessment\nDeployment (v1)"]
        TTG["Transaction Traffic Generator\nDeployment (v1)"]
        %% Connections
        TG --> TP
        TP --> AS
        TP --> FD
        TP --> RA
        TTG --> TP
    end
    style TG fill:#FFD580,stroke:#333,stroke-width:2px
    style TP fill:#90EE90,stroke:#333
    style AS fill:#ADD8E6,stroke:#333
    style FD fill:#ADD8E6,stroke:#333
    style RA fill:#ADD8E6,stroke:#333
    style TTG fill:#FFB6C1,stroke:#333
```

1. Point your `kubectx` to the cluster where you;d like to install the app

```sh
kubectx <your cluster>
```

2. Run this command from `/tetrate-platform-ntt/demos/helm` directory:

```sh
kubectl create namespace transaction-oversight
kubectl label namespace transaction-oversight istio-injection=enabled

helm install transaction-portal ./app \
  --namespace transaction-oversight
```

You should see something like:

```sh
helm install transaction-portal ./app \
  --namespace transaction-oversight
NAME: transaction-portal
LAST DEPLOYED: Fri Sep 19 15:24:54 2025
NAMESPACE: transaction-oversight
STATUS: deployed
REVISION: 1
TEST SUITE: None
```

3. Validation:

```sh
kubectl get pods -n transaction-oversight
```

You should see something like:

```sh
kubectl get pods -n transaction-oversight
NAME                                            READY   STATUS    RESTARTS   AGE
account-service-v1-75df854b6d-mppkq             2/2     Running   0          20s
fraud-detection-v2-7d6c76d949-fxm85             2/2     Running   0          20s
risk-assessment-v1-6cb6c47b66-ngkx4             2/2     Running   0          20s
transaction-gw-7ff794d556-njqtq                 1/1     Running   0          19s
transaction-portal-v2-679fcc5d5b-rng9s          2/2     Running   0          20s
transaction-traffic-generator-56ddfb497-mj7dw   2/2     Running   0          20s
```




