# agent

![Version: 0.5.1](https://img.shields.io/badge/Version-0.5.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.8.0](https://img.shields.io/badge/AppVersion-0.8.0-informational?style=flat-square)

AppTrail Agent - Kubernetes controller that tracks workload version changes and exports metrics

**Homepage:** <https://github.com/apptrail-sh/helm-charts>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| AppTrail |  | <https://github.com/apptrail-sh> |

## Source Code

* <https://github.com/apptrail-sh/agent>

## Requirements

Kubernetes: `>=1.26.0-0`

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | Affinity rules |
| agent.clusterId | string | `""` | Unique identifier for this cluster (optional - auto-detected on GKE) |
| agent.enableHTTP2 | bool | `false` | Enable HTTP/2 (disabled by default for security) |
| agent.healthProbeBindAddress | string | `":8081"` | Health probe bind address |
| agent.leaderElect | bool | `true` | Enable leader election for HA |
| agent.metricsBindAddress | string | `":8080"` | Metrics bind address |
| agent.metricsSecure | bool | `false` | Enable secure metrics (HTTPS) |
| controlplane.enabled | bool | `false` | Enable Control Plane integration |
| controlplane.url | string | `""` | Control Plane URL (e.g., http://apptrail-controlplane:3000/api/v1/events) |
| extraArgs | list | `[]` | Extra arguments to pass to the agent |
| extraEnv | list | `[]` | Extra environment variables |
| fullnameOverride | string | `""` | Override the full resource name |
| image.pullPolicy | string | `"IfNotPresent"` | Image pull policy |
| image.repository | string | `"ghcr.io/apptrail-sh/agent"` | Container image repository |
| image.tag | string | `""` | Overrides the image tag (default: chart appVersion) |
| imagePullSecrets | list | `[]` | Image pull secrets for private registries |
| livenessProbe.httpGet.path | string | `"/healthz"` |  |
| livenessProbe.httpGet.port | int | `8081` |  |
| livenessProbe.initialDelaySeconds | int | `15` |  |
| livenessProbe.periodSeconds | int | `20` |  |
| metrics.enabled | bool | `true` | Enable metrics service |
| metrics.service.annotations | object | `{}` | Metrics service annotations |
| metrics.service.port | int | `8080` | Metrics service port |
| metrics.serviceMonitor | object | `{"enabled":false,"interval":"30s","labels":{},"namespace":"","scrapeTimeout":"10s"}` | ServiceMonitor for Prometheus Operator |
| metrics.serviceMonitor.interval | string | `"30s"` | Interval for scraping |
| metrics.serviceMonitor.labels | object | `{}` | Additional labels for ServiceMonitor |
| metrics.serviceMonitor.namespace | string | `""` | Namespace for ServiceMonitor (defaults to chart namespace) |
| metrics.serviceMonitor.scrapeTimeout | string | `"10s"` | Scrape timeout |
| nameOverride | string | `""` | Override the chart name |
| nodeSelector | object | `{}` | Node selector |
| podAnnotations | object | `{}` | Pod annotations |
| podLabels | object | `{}` | Pod labels |
| podSecurityContext.runAsNonRoot | bool | `true` |  |
| podSecurityContext.seccompProfile.type | string | `"RuntimeDefault"` |  |
| pubsub.enabled | bool | `false` | Enable Google Cloud Pub/Sub publisher |
| pubsub.topic | string | `""` | Pub/Sub topic path (e.g., projects/<project>/topics/<topic>) |
| rbac.create | bool | `true` | Create ClusterRole and ClusterRoleBinding |
| readinessProbe.httpGet.path | string | `"/readyz"` |  |
| readinessProbe.httpGet.port | int | `8081` |  |
| readinessProbe.initialDelaySeconds | int | `5` |  |
| readinessProbe.periodSeconds | int | `10` |  |
| replicaCount | int | `1` | Number of replicas (should be 1 with leader election) |
| resources | object | `{"limits":{"cpu":"500m","memory":"128Mi"},"requests":{"cpu":"10m","memory":"64Mi"}}` | Resource requests and limits |
| securityContext.allowPrivilegeEscalation | bool | `false` |  |
| securityContext.capabilities.drop[0] | string | `"ALL"` |  |
| securityContext.readOnlyRootFilesystem | bool | `true` |  |
| securityContext.runAsNonRoot | bool | `true` |  |
| securityContext.runAsUser | int | `65532` |  |
| service.port | int | `8080` |  |
| service.type | string | `"ClusterIP"` |  |
| serviceAccount.annotations | object | `{}` | Annotations for the service account |
| serviceAccount.automount | bool | `true` | Automount API credentials |
| serviceAccount.create | bool | `true` | Create a service account |
| serviceAccount.name | string | `""` | Service account name (auto-generated if not set) |
| slack.enabled | bool | `false` | Enable Slack notifications |
| slack.existingSecret | string | `""` | Existing secret containing Slack webhook URL (key: webhook-url) |
| slack.webhookUrl | string | `""` | Slack webhook URL |
| tolerations | list | `[]` | Tolerations |
| volumeMounts | list | `[]` | Additional volume mounts |
| volumes | list | `[]` | Additional volumes |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
