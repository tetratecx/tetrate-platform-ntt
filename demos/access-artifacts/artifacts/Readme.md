# Access and Guidance

## Tetrate Platform

Go to [https://dynabank.cloud.tetrate.com/login](https://dynabank.cloud.tetrate.com/login) to access Tetrate Platform UI - admin access

```sh
admin/Tetrate123
```

## Access to kubernetes clusters

Ask Tetrate for the access

## Explore the Demo Menu to Become Familiar with Tetrate Platform Features, Value, and Capabilities

Click any demo from the left menu to start a deep dive

## Git Repository Access

Clone this repository to access all demo artifacts:

```sh
git clone https://github.com/tetratecx/tetrate-platform-ntt.git
cd tetrate-platform-ntt
```

## Important Notes

- All demo resources — including applications and Tetrate configurations — are managed using **GitOps via ArgoCD**.
- If you need to modify any existing configuration, disable **ArgoCD** sync first, otherwise your changes will be overwritten.
- Each demo includes its own usage instructions and validation steps (for example: `task traffic-generation`).
- Some commands (such as `kubectl apply` or `task` commands) should be executed from the corresponding directory:

```sh
demos/<demo-name>/artifacts/
```

Example:

```sh
cd demos/app-resilience/artifacts
task generate-traffic
kubectl apply -f <file-name>.yaml
```

## Enjoy the demos!
