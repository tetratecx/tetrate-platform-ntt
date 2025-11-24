# Deploy and Expose APIs using Tetrate Gateway within minutes

**Goal**: From URL access to exposing your first API through Tetrate in few minutes.

## Prerequisites (5 minutes)

### Required Tools
- Kubernetes cluster(s) access
- `kubectl` configured
- `kubectx` configured
- `helm` installed

### Tetrate Management Plane Access

**URL:** `dynabank.cloud.tetrate.com`  
**Username:** `admin`  
**Password:** `******`

## Step 1: Connect to Tetrate Management Plane (5 minutes)

### Download tctl CLI

```sh
# Quick one-line installation (Linux & macOS)
curl -sL https://charts.dl.tetrate.io/public/raw/files/get-tctl.sh | bash
```

### Configure tctl Connection

```sh
# Quick connect
tctl config clusters set default --bridge-address dynabank.cloud.tetrate.com:443
tctl config users set default --username admin --password <replace-me> --org tetrate
tctl config profiles set default --cluster default --username default
tctl config profiles set-current default

# Verify connection
tctl version
```

## Step 2: Onboard Your Cluster (few minutes)

### One-Command Installation

```sh
# Replace 'cluster name' with your actual cluster name
curl -s https://charts.dl.tetrate.io/public/raw/files/onboard-cluster.sh | bash -s west-cluster
```

### Expected Output
```
[INFO] Starting Tetrate cluster onboarding for: cluster1
[SUCCESS] Prerequisites check passed
[SUCCESS] Cluster service account registered
[SUCCESS] Configuration template generated
[SUCCESS] Configuration patches applied
[SUCCESS] Helm repository updated
[SUCCESS] Tetrate Control Plane installed
[SUCCESS] Tetrate Hosted Agent installed
[SUCCESS] Tetrate cluster onboarding completed for 'cluster1'
```

## Step 3: Deploy Sample Application (5 minutes)

```sh
# Create namespace and enable injection
kubectx west-cluster
kubectl create namespace api-broker
kubectl label namespace api-broker tetrate.io/rev=default
kubectl label namespace api-broker istio-injection=enabled

# Deploy sample app
kubectl apply -n api-broker -f https://raw.githubusercontent.com/istio/istio/master/samples/httpbin/httpbin.yaml
```

## Step 4: Expose API via Gateway (5 minutes)

### Add Gateway Annotations

```sh
# Expose service through Tetrate gateway
kubectl patch service httpbin -n api-broker -p '{"metadata":{"annotations":{"gateway.tetrate.io/host":"api-broker.box.io"}}}'
```

**Optional: AWS Load Balancer with HTTPS Configuration**

If running on AWS, you can configure HTTPS with TLS termination and enhanced NLB settings:

#### Create TLS Certificate and Secret

```sh
# Generate a self-signed certificate (for testing)
openssl req -x509 -nodes -days 30 -newkey rsa:2048 \
  -keyout /tmp/tls.key -out /tmp/tls.crt \
  -subj "/CN=api-broker.box.io"

# Create TLS secret in tetrate-system namespace
kubectl create secret tls boxdev-app-tls \
  --cert=/tmp/tls.crt \
  --key=/tmp/tls.key \
  -n tetrate-system
```

#### Configure HTTPS Gateway with AWS NLB

**Note**: This configuration creates an external, internet-facing gateway that will be reachable from outside your VPC.

```sh
kubectl patch service httpbin -n api-broker -p '{
  "metadata": {
    "annotations": {
      "gateway.tetrate.io/host": "api-broker.box.io",
      "gateway.tetrate.io/local-port": "8000",
      "gateway.tetrate.io/protocol": "HTTPS",
      "gateway.tetrate.io/tls-secret": "boxdev-app-tls",
      "gateway.tetrate.io/workload-selector": "app=external-gateway",
      "gateway.tetrate.io/gateway-namespace": "tetrate-system",
      "gateway.tetrate.io/cloud-annotations": "service.beta.kubernetes.io/aws-load-balancer-type: \"nlb\"\nservice.beta.kubernetes.io/aws-load-balancer-scheme: \"internet-facing\"\nservice.beta.kubernetes.io/aws-load-balancer-cross-zone-load-balancing-enabled: \"true\"\nservice.beta.kubernetes.io/aws-load-balancer-target-group-attributes: \"preserve_client_ip.enabled=true\""
    }
  }
}'
```

**HTTP Only Configuration (Alternative)**

For HTTP-only setup with enhanced AWS NLB settings:

```sh
kubectl patch service httpbin -n api-broker -p '{
  "metadata": {
    "annotations": {
      "gateway.tetrate.io/host": "api-broker.box.io",
      "gateway.tetrate.io/local-port": "8000",
      "gateway.tetrate.io/workload-selector": "app=external-gateway",
      "gateway.tetrate.io/gateway-namespace": "tetrate-system",
      "gateway.tetrate.io/cloud-annotations": "service.beta.kubernetes.io/aws-load-balancer-type: \"nlb\"\nservice.beta.kubernetes.io/aws-load-balancer-scheme: \"internet-facing\"\nservice.beta.kubernetes.io/aws-load-balancer-cross-zone-load-balancing-enabled: \"true\"\nservice.beta.kubernetes.io/aws-load-balancer-target-group-attributes: \"preserve_client_ip.enabled=true\""
    }
  }
}'
```

### Get Your API Endpoint

```sh
# Retrieve gateway endpoint (AWS returns hostname, GCP/Azure return IP)
export GATEWAY_ENDPOINT=$(kubectl get svc gateway -n tetrate-system -o jsonpath='{.status.loadBalancer.ingress[0]}' | jq -r '.ip // .hostname')

# Display access information
echo "Your API is available at: http://$GATEWAY_ENDPOINT/"
echo "HTTPS endpoint (if configured): https://$GATEWAY_ENDPOINT/"
echo ""
echo "Test endpoints (requires Host header):"
echo "  GET:     curl -H 'Host: api-broker.box.io' http://$GATEWAY_ENDPOINT/get"
echo "  Headers: curl -H 'Host: api-broker.box.io' http://$GATEWAY_ENDPOINT/headers"
echo "  Status:  curl -H 'Host: api-broker.box.io' http://$GATEWAY_ENDPOINT/status/200"
echo ""
echo "HTTPS endpoints (if TLS configured):"
echo "  GET:     curl -k -H 'Host: api-broker.box.io' https://$GATEWAY_ENDPOINT/get"
echo "  Headers: curl -k -H 'Host: api-broker.box.io' https://$GATEWAY_ENDPOINT/headers"
```

## Verification

### Test Your Exposed API

**HTTP Endpoints**

**Basic GET Request**
```sh
curl -H "Host: api-broker.box.io" http://$GATEWAY_ENDPOINT/get

# Alternative using --resolve (no Host header needed)
curl --resolve api-broker.box.io:80:$GATEWAY_ENDPOINT http://api-broker.box.io/get
```

**Headers Inspection**
```sh
curl -H "Host: api-broker.box.io" http://$GATEWAY_ENDPOINT/headers
```

**Status Check**
```sh
curl -H "Host: api-broker.box.io" http://$GATEWAY_ENDPOINT/status/200
```

**POST with JSON Data**
```sh
curl -X POST -H "Host: api-broker.box.io" -H "Content-Type: application/json" \
     http://$GATEWAY_ENDPOINT/post -d '{"test": "data"}'
```

**HTTPS Endpoints (if TLS configured)**

**Secure GET Request**
```sh
curl -k -H "Host: api-broker.box.io" https://$GATEWAY_ENDPOINT/get

# Alternative using --resolve (no Host header needed)
curl -k --resolve api-broker.box.io:443:$GATEWAY_ENDPOINT https://api-broker.box.io/get
```

**Secure Headers Inspection**
```sh
curl -k -H "Host: api-broker.box.io" https://$GATEWAY_ENDPOINT/headers
```

**Secure POST with JSON**
```sh
curl -k -X POST -H "Host: api-broker.box.io" -H "Content-Type: application/json" \
     https://$GATEWAY_ENDPOINT/post -d '{"test": "secure data"}'
```


### Observe

Login to Tetrate Platform UI and explore the Topology View, Metrics, Logs, Analytics

## Troubleshooting

**Service Not Responding**

Consult `Gateway Services` tab within Tetrate UI for more information.

```sh
# Verify pod is running
kubectl get pods -n api-broker

# Check annotations are applied
kubectl get svc httpbin -n api-broker -o jsonpath='{.metadata.annotations}'
```

**Need Help?**

- Check the [Gateway Annotations User Guide](./gateway-annotations-user-guide.md)
- Review agent logs: `kubectl logs -n istio-system deployment/tetrate-hosted-agent`

### Support Resources

- [Tetrate Documentation](https://docs.tetrate.io/service-bridge)
- [Tetrate CLI Guide](https://docs.tetrate.io/service-bridge/reference/cli/guide/index)
- [Requirements and Download](https://docs.tetrate.io/service-bridge/latest/en-us/setup/requirements-and-download)
- [Acquire Tetrate Images](./images.md)
- [Helm Control Plane Deployment](https://docs.tetrate.io/service-bridge/latest/en-us/setup/helm/controlplane)
