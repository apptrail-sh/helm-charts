# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

Helm charts for [AppTrail](https://github.com/apptrail-sh) — Kubernetes workload version tracking and DORA metrics. Two charts:

- **apptrail-agent** (`charts/apptrail-agent/`) — Per-cluster K8s controller that watches workloads for version changes. Includes CRDs, ClusterRole RBAC, ServiceMonitor for Prometheus.
- **apptrail-controlplane** (`charts/apptrail-controlplane/`) — Central API server (Spring Boot on port 3000) + Web UI. Uses a ConfigMap-based appConfig pattern for Spring Boot external YAML overrides.

## Commands

```bash
# Lint charts (primary validation)
ct lint --config ct.yaml

# Validate individual chart
helm lint charts/apptrail-agent
helm lint charts/apptrail-controlplane

# Render templates locally (inspect output without installing)
helm template test charts/apptrail-agent
helm template test charts/apptrail-controlplane

# Validate rendered manifests against K8s schemas
helm template test charts/apptrail-agent | kubeconform -strict -ignore-missing-schemas
helm template test charts/apptrail-controlplane | kubeconform -strict -ignore-missing-schemas

# Generate/update chart README from values.yaml comments
helm-docs

# Integration test (requires kind cluster)
kind create cluster --name chart-testing
ct install --config ct.yaml
kind delete cluster --name chart-testing
```

## Chart Conventions

### Template helpers
Each chart has `_helpers.tpl` with standard helpers prefixed by chart name: `agent.fullname`, `agent.labels`, `agent.selectorLabels`, `agent.serviceAccountName` (and `controlplane.*` equivalents). The controlplane chart also has `controlplane.appConfig.active` to conditionally mount the Spring Boot config override.

### Values documentation
All values use `# --` comment prefix for [helm-docs](https://github.com/norwoodj/helm-docs) generation. CI checks that docs are up to date — always run `helm-docs` after changing values.yaml.

### Security contexts (required defaults)
Both charts enforce: `runAsNonRoot: true`, `readOnlyRootFilesystem: true`, `allowPrivilegeEscalation: false`, `drop: [ALL]` capabilities, `seccompProfile: RuntimeDefault`. The controlplane chart mounts an emptyDir at `/tmp` to support readOnlyRootFilesystem with Spring Boot.

### Controlplane appConfig pattern
The controlplane uses `controlplane.appConfig.content` (inline YAML) or `controlplane.appConfig.existingConfigMap` to mount a Spring Boot config override file. When active, the deployment sets `SPRING_CONFIG_ADDITIONAL_LOCATION` env var and includes a config checksum annotation for automatic rollout on config changes.

### Values structure difference
- **Agent**: flat top-level values (`image`, `replicaCount`, `securityContext`, `resources`)
- **Controlplane**: nested under `controlplane.*` (`controlplane.image`, `controlplane.replicaCount`, `controlplane.securityContext`, `controlplane.resources`)

## CI/CD Pipeline

- **lint.yaml** (PR): chart-testing lint, kubeconform validation, Trivy security scan, helm-docs freshness check
- **test.yaml** (PR): chart-testing install on kind cluster (controlplane excluded — needs PostgreSQL)
- **release.yaml** (push to main): chart-releaser to GitHub Pages + OCI push to `ghcr.io/apptrail-sh/charts`
- **sync-agent.yaml** (PR): auto-syncs agent CRD and bumps chart version when Renovate updates `appVersion`

## Agent CRD Sync Automation

Renovate tracks `appVersion` in `charts/apptrail-agent/Chart.yaml` via a custom regex manager. When it opens a PR:
1. `sync-agent.yaml` workflow detects the Renovate branch
2. Runs `scripts/sync-agent-crd.sh` which downloads the CRD from the agent release, auto-detects semver bump type, updates `Chart.yaml` version, and regenerates helm-docs
3. Bump type can be overridden with PR labels: `bump:major`, `bump:minor`, `bump:patch`
4. Skip sync entirely with label: `skip-version-sync`

## Making Changes

1. Edit chart files in `charts/`
2. Bump `version` in the chart's `Chart.yaml` (CI enforces version increment via `check-version-increment: true`)
3. Run `helm-docs` to regenerate README
4. Run `ct lint --config ct.yaml` to validate

## Don't

- Create a standalone ui chart (ui chart is merged into controlplane)
- Skip security contexts on new templates
- Hardcode values in templates — use values.yaml
- Forget to bump `Chart.yaml` version — CI will reject unchanged versions
