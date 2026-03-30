# checkout-api Helm Chart

Deploys the Xsolla School Checkout API on GKE.

## Installation

### From the Helm repository (recommended)

```bash
helm repo add xsolla-school https://ahmedzidan.github.io/helm-charts
helm repo update

helm upgrade --install checkout-api xsolla-school/checkout-api \
  --namespace student-<your-name> \
  --create-namespace \
  --set image.tag=<git-sha> \
  --set database.url="postgresql://user:pass@host:5432/db"
```

### From source

```bash
git clone git@github.com:ahmedzidan/helm-charts.git
cd helm-charts

helm upgrade --install checkout-api ./charts/checkout-api \
  --namespace student-<your-name> \
  --create-namespace \
  --set image.tag=<git-sha> \
  --set database.url="postgresql://user:pass@host:5432/db"
```

## Environment-specific deployments

### Dev (no ingress, minimal resources)

```bash
helm upgrade --install checkout-api ./charts/checkout-api \
  --namespace student-<your-name> \
  --create-namespace \
  --values ./charts/checkout-api/values-dev.yaml \
  --set image.tag=<git-sha> \
  --set database.url="postgresql://user:pass@host:5432/db"
```

Access the service locally via port-forward (ingress is disabled in dev):

```bash
kubectl port-forward svc/checkout-api-service 8080:80 -n student-<your-name>
# App is now available at http://localhost:8080
```

### Staging (GKE Ingress, 2 replicas)

```bash
helm upgrade --install checkout-api ./charts/checkout-api \
  --namespace student-<your-name> \
  --create-namespace \
  --values ./charts/checkout-api/values-staging.yaml \
  --set image.tag=<git-sha> \
  --set database.url="postgresql://user:pass@host:5432/db"
```

## Configuration

All configurable values with their defaults:

| Key | Default | Description |
|-----|---------|-------------|
| `image.registry` | `us-west2-docker.pkg.dev/xsolla-school-experiments` | GCP Artifact Registry host/project |
| `image.arRepo` | `checkout-api` | Artifact Registry repository name |
| `image.repository` | `checkout-api` | Image name |
| `image.tag` | `latest` | Image tag — set to `$CI_COMMIT_SHA` in CI |
| `image.pullPolicy` | `IfNotPresent` | Kubernetes image pull policy |
| `replicaCount` | `1` | Number of pod replicas |
| `service.type` | `NodePort` | Kubernetes service type (`NodePort` required for GKE Ingress) |
| `service.port` | `80` | Service port (external) |
| `service.targetPort` | `8080` | Container port |
| `ingress.enabled` | `true` | Create a GKE Ingress resource |
| `ingress.className` | `gce` | Ingress class (`gce` = Google Cloud Load Balancer) |
| `ingress.host` | `""` | Hostname (leave empty for IP-based access) |
| `resources.requests.cpu` | `100m` | CPU request |
| `resources.requests.memory` | `128Mi` | Memory request |
| `resources.limits.cpu` | `500m` | CPU limit |
| `resources.limits.memory` | `256Mi` | Memory limit |
| `probes.readiness.initialDelaySeconds` | `5` | Readiness probe initial delay |
| `probes.readiness.periodSeconds` | `10` | Readiness probe interval |
| `probes.liveness.initialDelaySeconds` | `15` | Liveness probe initial delay |
| `probes.liveness.periodSeconds` | `20` | Liveness probe interval |
| `database.url` | `postgresql://postgres:postgres@postgres-service:5432/postgres` | Database connection string (stored in a Secret) |

## How secrets are handled

`database.url` is stored in a Kubernetes Secret (`postgres-secret`) and injected into the container as the `DATABASE_URL` environment variable. Never commit real credentials — always pass them at deploy time:

```bash
--set database.url="$DATABASE_URL"
```

For production workloads consider using [External Secrets Operator](https://external-secrets.io) with GCP Secret Manager instead.

## Uninstalling

```bash
helm uninstall checkout-api -n student-<your-name>
```
