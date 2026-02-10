# AppTrail Helm Charts

[![Lint and Validate](https://github.com/apptrail-sh/helm-charts/actions/workflows/lint.yaml/badge.svg)](https://github.com/apptrail-sh/helm-charts/actions/workflows/lint.yaml)
[![Release Charts](https://github.com/apptrail-sh/helm-charts/actions/workflows/release.yaml/badge.svg)](https://github.com/apptrail-sh/helm-charts/actions/workflows/release.yaml)

Official Helm charts for [AppTrail](https://github.com/apptrail-sh) - Kubernetes workload version tracking and DORA metrics.

## Charts

| Chart | Description |
|-------|-------------|
| [agent](./charts/agent) | Kubernetes controller that watches workloads for version changes (deploy per cluster) |
| [controlplane](./charts/controlplane) | API server + Web UI for aggregating and viewing workload data (deploy once, centrally) |

## Architecture

```
┌─────────────────────┐     ┌─────────────────────┐     ┌─────────────────────┐
│   Cluster A         │     │   Cluster B         │     │   Cluster C         │
│   ┌─────────────┐   │     │   ┌─────────────┐   │     │   ┌─────────────┐   │
│   │    agent    │   │     │   │    agent    │   │     │   │    agent    │
│   └─────────────┘   │     │   └─────────────┘   │     │   └─────────────┘   │
└─────────────────────┘     └─────────────────────┘     └─────────────────────┘
           │                         │                         │
           └─────────────────────────┼─────────────────────────┘
                                     ▼
                    ┌────────────────────────────────┐
                    │     Central Infrastructure     │
                    │  ┌──────────────────────────┐  │
                    │  │  apptrail-controlplane   │  │
                    │  │  ┌────────┐ ┌─────────┐  │  │
                    │  │  │  API   │ │ Web UI  │  │  │
                    │  │  └────────┘ └─────────┘  │  │
                    │  └──────────────────────────┘  │
                    │             │                  │
                    │             ▼                  │
                    │        PostgreSQL              │
                    └────────────────────────────────┘
```

## Usage

### Add Helm Repository

```bash
helm repo add apptrail https://apptrail-sh.github.io/helm-charts
helm repo update
```

### Install the Control Plane (Central)

Deploy once in your central/management cluster:

```bash
helm install apptrail apptrail/controlplane \
  --namespace apptrail \
  --create-namespace \
  --set database.url=postgres://user:pass@host:5432/apptrail
```

The control plane includes the web UI by default. To disable:

```bash
helm install apptrail apptrail/controlplane \
  --set ui.enabled=false \
  # ... other values
```

### Install the Agent (Per Cluster)

Deploy in each cluster you want to track:

```bash
helm install apptrail-agent apptrail/agent \
  --namespace apptrail-system \
  --create-namespace \
  --set controlplane.enabled=true \
  --set controlplane.url=http://apptrail-controlplane.apptrail.svc.cluster.local:3000/api/v1/events \
  --set controlplane.clusterId=my-cluster-name
```

### Using OCI Registry (Alternative)

Charts are also available via GHCR OCI registry:

```bash
# Install from OCI registry
helm install apptrail oci://ghcr.io/apptrail-sh/charts/controlplane \
  --namespace apptrail \
  --create-namespace
```

## Configuration

See each chart's `values.yaml` for configuration options:

- [agent values](./charts/agent/values.yaml)
- [controlplane values](./charts/controlplane/values.yaml)

### Control Plane with UI Ingress

```yaml
# values.yaml
database:
  url: postgres://user:pass@host:5432/apptrail

# API ingress (optional)
ingress:
  enabled: true
  hosts:
    - host: api.apptrail.example.com
      paths:
        - path: /
          pathType: Prefix

# UI configuration
ui:
  enabled: true
  ingress:
    enabled: true
    hosts:
      - host: apptrail.example.com
        paths:
          - path: /
            pathType: Prefix
```

## Requirements

- Kubernetes 1.26+
- Helm 3.x
- PostgreSQL (for control plane)

## Development

### Prerequisites

- [Helm](https://helm.sh/docs/intro/install/)
- [helm-docs](https://github.com/norwoodj/helm-docs)
- [chart-testing](https://github.com/helm/chart-testing)
- [kind](https://kind.sigs.k8s.io/) (for local testing)

### Local Testing

```bash
# Lint charts
ct lint --config ct.yaml

# Test chart installation (requires kind cluster)
kind create cluster --name chart-testing
ct install --config ct.yaml

# Generate documentation
helm-docs
```

### Making Changes

1. Update chart files in `charts/`
2. Bump version in `Chart.yaml`
3. Run `helm-docs` to update documentation
4. Create PR - CI will run lint and tests
5. Merge to main - charts will be released automatically

## License

Apache 2.0 - see [LICENSE](LICENSE) for details.
