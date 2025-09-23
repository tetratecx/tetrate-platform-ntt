## What legacy demonstrates?

### Deployment

- Single giant container instead of separate services.
- Tightly coupled domains: account, fraud, risk, reporting, UI all in one.
- Hardcoded passwords/configs → security nightmare.
- Massive config file mixing unrelated concerns.
- Single point of failure → if fraud logic crashes, the whole portal dies.
- Difficult to scale → can’t scale fraud detection independently.
- Slow deployments → every change required redeploying the whole monster.

👉 This contrasts nicely with the microservices YAML you shared earlier, where things are broken into account-service, fraud-detection, risk-assessment, etc.

### Java Code - "bad code"

- Single giant class (TransactionPortal.java) handling all domains.
- No separation of concerns (account, fraud, risk, portal mixed together).
- Hardcoded logic (new Random().nextBoolean() fraud check 😅).
- In-memory data instead of proper persistence.
- Hard to scale: can’t split fraud detection into a separate service.
- Hard to test: everything coupled together, no interfaces or mocks.
- Console logging only → no observability or metrics.
- Feature flags = copy-paste: switching logic requires editing this same class.

👉 This pairs really well with the legacy monolith YAML — the “monster container” running this giant blob of code.