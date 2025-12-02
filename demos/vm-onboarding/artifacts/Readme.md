# Overview
When you deploy a workload on Kubernetes, the following happens transparently:

1. An Istio sidecar is deployed next to your workload.
That sidecar is configured with the workload location and other required metadata.
2. However, when you deploy a workload outside of Kubernetes onto a standalone VM, you have to take care of that by yourself.

The Workload Onboarding feature solves this problem for you out of the box. Using this feature, all you need to do to onboard a workload deployed on a VM into the mesh is:

1. Installing an Istio sidecar on the target VM (via DEB/RPM package).
2. Install a Workload Onboarding Agent on the target VM (also via DEB/RPM package).
3. Provide a minimal, declarative configuration describing where to onboard the workload, e.g.

```
apiVersion: config.agent.onboarding.tetrate.io/v1alpha1
kind: OnboardingConfiguration
onboardingEndpoint:                            # connect to
  host: onboarding-endpoint.your-company.corp
workloadGroup:                                 # join to
  namespace: bookinfo
  name: ratings
```

# Components and Workflow
The Workload Onboarding consists of the following components:

| Component                    | Description                                                                                     |
|-----------------------------|-------------------------------------------------------------------------------------------------|
| Workload Onboarding Operator | the component that is installed into your Kubernetes cluster as part of the TSB Control Plane   |
| Workload Onboarding Agent    | the component you need to install next to your VM workload                                      |
| Workload Onboarding Endpoint | the component which the Workload Onboarding Agent will connect to register the workload in the mesh and obtain boot configuration for the Istio sidecar |

The following diagram has an overview of the full onboarding flow:

<figure markdown>
  ![obs1](../images/vm-onboarding/vm1.jpg)
</figure>

The Workload Onboarding Agent executes the onboarding flow according to the declarative configuration provided by the user.

```
apiVersion: config.agent.onboarding.tetrate.io/v1alpha1
kind: OnboardingConfiguration
onboardingEndpoint:                           # (1)
  host: onboarding-endpoint.your-company.corp
workloadGroup:                                # (2)
  namespace: bookinfo
  name: ratings
```

Given the above configuration, the following takes place:

1. The Workload Onboarding Agent will connect to the Workload Onboarding Endpoint at https://onboarding-endpoint.your-company.corp:15443 (1)
2. The Workload Onboarding Endpoint will authenticate the connecting Agent from the cloud-specific credentials of the VM
3. The Workload Onboarding Endpoint will decide whether a workload with such an identity, i.e. the identity of the VM, is authorized to join the mesh in the given WorkloadGroup (2) in particular
4. The Workload Onboarding Endpoint will register a new WorkloadEntry at the Istio Control Plane to represent the workload
5. The Workload Onboarding Endpoint will generate the boot configuration required to start Istio Proxy according to the respective WorkloadGroup resource (2)
6. The Workload Onboarding Agent will save the returned boot configuration to disk and start the Istio sidecar
7. The Istio sidecar will connect to the Istio Control Plane and receive its runtime configuration