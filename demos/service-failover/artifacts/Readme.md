# Service-Failover Demo

Welcome to the Service Failover Demo.
In this demo, we will show how Tetrate Platform handles microservice failover across clusters.

### Overview
Tetrate Platform ensures that applications and services remain available, reliable, and resilient even when parts of the environment fail.

### Why This Matters
- **Without failover:** If a local microservice instance, cluster, or region goes down, users immediately see errors or downtime.  
- **With Tetrate Platform failover:** Traffic can be automatically rerouted to healthy instances of the same service in another cluster, region, or cloud.  
- Applications can survive localized outages without disruption.  
- Failover ensures user requests continue to be served during failures with minimal latency. Traffic loss is mitigated through intelligent retries and an outlier detection logic.  

### Problem Statement
Traditional failover relies on external systems, such as GTM/LTM.
This leads to:  
- Increased recovery time  
- Traffic loss  
- External dependenciers   

### How Tetrate Platform Solves It
- Automatic failover ensures uninterrupted service continuity without user-visible errors.
- East-West Gateways facilitate communication between services across clusters.
- Outlier detection and retries minimize traffic loss
- Locality-Based Routing prioritizes local services over remote services.


### Demo at a Glance
We have the same application deployed in two clusters in different clouds. We will fail one of the services and observe traffic failover between clusters.

<figure markdown>
  ![Service Failover](../images/service-failover/svc-failover-before.png)
  <figcaption>Local cluster communications between transaction portal and risk-assessement services</figcaption>
</figure>

### Prerequisites
- Complete Inter Cluster Demo
- `kubectl` and `kubectx`
- [`task`](https://taskfile.dev) (task runner)


## Running the Demo

### Generate Traffic

Start continuous traffic generation to your application:
```sh
task generate-traffic
```

### Fail local cluster service

Run these commands to simulate a failure of the local cluster service
```sh
kubectx east-cluster
task break-workload
```

### While traffic running go to Tetrate Platform UI to observe

You should see now cross cluster traffic between `transaction-portal` and `risk-assessment` via East-West Gateway, mTLS encrypted

<figure markdown>
  ![Service Failover](../images/service-failover/svc-failover-after.png)
  <figcaption>Cross-cluster communications via East-West Gateway to remote cluster with risk-assessment healthy service</figcaption>
</figure>

## Why It Matters — For the Product, the Business, and the End Users (with East-West & Progressive Delivery Support)

**For the Product:**  
Tetrate Platform delivers full multi-cluster resiliency — not just at the edge, but also inside the mesh. Its EastWest Gateway capability enables fully automated, cross-cluster failover for internal services. If a service fails in one cluster, traffic transparently shifts to a healthy instance in another region — all without manual intervention. 
Tetrate Platform also supports modern deployment strategies like Canary release and Blue‑Green deployment out of the box, enabling safe, incremental or instantaneous version rollouts with minimal risk.  

**For the Business:**  
This means continuous reliability and business continuity: internal and external services stay available even when entire clusters fail or are being upgraded. Fewer outages, fewer operational emergencies, fewer support tickets — that translates directly into lower operational cost, better SLA compliance, and stronger customer trust. Tetrate Platform’s unified control plane reduces complexity and consolidates governance, security, and traffic-management under a single platform — ideal for enterprise scale and compliance requirements.

**For End Users:**  
Users will never see failure — or even a blip. Whether you’re rolling out a new version canary-style, switching environment via blue-green swap, or recovering from a cluster outage — traffic routing, failover, and deployment rollouts all stay invisible to the user. The experience remains seamless, stable, and consistent.  

**In one line:**  
With Tetrate Platform, your apps evolve, recover, and scale — without downtime, without risk, and without users ever noticing.  
