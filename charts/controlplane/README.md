# controlplane

![Version: 0.7.0](https://img.shields.io/badge/Version-0.7.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.5.0](https://img.shields.io/badge/AppVersion-0.5.0-informational?style=flat-square)

AppTrail Control Plane - API server for aggregating and querying workload version data

**Homepage:** <https://github.com/apptrail-sh/helm-charts>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| AppTrail |  | <https://github.com/apptrail-sh> |

## Source Code

* <https://github.com/apptrail-sh/controlplane>
* <https://github.com/apptrail-sh/ui>

## Requirements

Kubernetes: `>=1.26.0-0`

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| commonLabels | object | `{}` | Common labels to add to all resources |
| controlplane.affinity | object | `{}` | Affinity rules |
| controlplane.appConfig.content | object | `{}` | Inline YAML content for the config file Example: content:   apptrail:     clusters:       definitions:         my-cluster:           environment: staging           cell:             name: canary             order: 0     notifications:       channels:         - name: "prod-alerts"           type: slack           enabled: true           notification-types: [DEPLOYMENT_FAILED]           slack:             webhook-url: "${SLACK_WEBHOOK_URL:}"             channel: "#alerts"     quick-links:       links:         - name: "Grafana"           urlTemplate: "https://grafana.example.com/..."           linkType: url           icon: grafana |
| controlplane.appConfig.existingConfigMap | string | `""` | Use an existing ConfigMap instead of generating one |
| controlplane.appConfig.key | string | `"application-override.yml"` | Key in the ConfigMap containing the YAML config |
| controlplane.envFrom | list | `[]` | Environment variable sources (secretRef/configMapRef for envFrom) Example: envFrom:   - secretRef:       name: my-app-secrets   - configMapRef:       name: my-app-config |
| controlplane.extraEnv | list | `[]` | Extra environment variables |
| controlplane.httpRoute.annotations | object | `{}` | HTTPRoute annotations |
| controlplane.httpRoute.enabled | bool | `false` | Enable controlplane API HTTPRoute (Gateway API) |
| controlplane.httpRoute.hostnames | list | `["api.apptrail.local"]` | Hostnames to match |
| controlplane.httpRoute.parentRefs | list | `[]` | Parent gateway references |
| controlplane.httpRoute.rules | list | `[{"matches":[{"path":{"type":"PathPrefix","value":"/"}}]}]` | HTTPRoute rules (backendRefs auto-set to controlplane service if omitted) |
| controlplane.image.pullPolicy | string | `"IfNotPresent"` | Image pull policy |
| controlplane.image.repository | string | `"ghcr.io/apptrail-sh/controlplane"` | Container image repository |
| controlplane.image.tag | string | `""` | Overrides the image tag (default: chart appVersion) |
| controlplane.ingress.annotations | object | `{}` | Ingress annotations |
| controlplane.ingress.className | string | `""` | Ingress class name |
| controlplane.ingress.enabled | bool | `false` | Enable controlplane API ingress |
| controlplane.ingress.hosts | list | `[{"host":"api.apptrail.local","paths":[{"path":"/","pathType":"Prefix"}]}]` | Ingress hosts |
| controlplane.ingress.tls | list | `[]` | Ingress TLS configuration |
| controlplane.livenessProbe.httpGet.path | string | `"/health"` |  |
| controlplane.livenessProbe.httpGet.port | string | `"http"` |  |
| controlplane.livenessProbe.initialDelaySeconds | int | `30` |  |
| controlplane.livenessProbe.periodSeconds | int | `15` |  |
| controlplane.nodeSelector | object | `{}` | Node selector |
| controlplane.podAnnotations | object | `{}` | Pod annotations |
| controlplane.podLabels | object | `{}` | Pod labels |
| controlplane.podSecurityContext.runAsNonRoot | bool | `true` |  |
| controlplane.podSecurityContext.seccompProfile.type | string | `"RuntimeDefault"` |  |
| controlplane.readinessProbe.httpGet.path | string | `"/health"` |  |
| controlplane.readinessProbe.httpGet.port | string | `"http"` |  |
| controlplane.readinessProbe.initialDelaySeconds | int | `15` |  |
| controlplane.readinessProbe.periodSeconds | int | `10` |  |
| controlplane.replicaCount | int | `1` | Number of replicas |
| controlplane.resources | object | `{"limits":{"cpu":1,"memory":"512Mi"},"requests":{"cpu":"100m","memory":"256Mi"}}` | Resource requests and limits |
| controlplane.securityContext.allowPrivilegeEscalation | bool | `false` |  |
| controlplane.securityContext.capabilities.drop[0] | string | `"ALL"` |  |
| controlplane.securityContext.readOnlyRootFilesystem | bool | `true` |  |
| controlplane.securityContext.runAsNonRoot | bool | `true` |  |
| controlplane.securityContext.runAsUser | int | `65532` |  |
| controlplane.service.port | int | `3000` |  |
| controlplane.service.type | string | `"ClusterIP"` |  |
| controlplane.startupProbe.failureThreshold | int | `30` |  |
| controlplane.startupProbe.httpGet.path | string | `"/health"` |  |
| controlplane.startupProbe.httpGet.port | string | `"http"` |  |
| controlplane.startupProbe.periodSeconds | int | `2` |  |
| controlplane.tolerations | list | `[]` | Tolerations |
| controlplane.volumeMounts | list | `[]` | Additional volume mounts |
| controlplane.volumes | list | `[]` | Additional volumes |
| fullnameOverride | string | `""` | Override the full resource name |
| imagePullSecrets | list | `[]` | Image pull secrets for private registries |
| nameOverride | string | `""` | Override the chart name |
| serviceAccount.annotations | object | `{}` | Annotations for the service account |
| serviceAccount.automount | bool | `true` | Automount API credentials |
| serviceAccount.create | bool | `true` | Create a service account |
| serviceAccount.name | string | `""` | Service account name (auto-generated if not set) |
| ui.affinity | object | `{}` | Affinity rules |
| ui.apiBaseUrl | string | `""` | API base URL for the UI to connect to the control plane. Empty string means relative URLs (same-origin). Set to an external URL for cross-origin setups. |
| ui.enabled | bool | `false` | Enable the UI deployment |
| ui.extraEnv | list | `[]` | Extra environment variables |
| ui.httpRoute.annotations | object | `{}` | HTTPRoute annotations |
| ui.httpRoute.enabled | bool | `false` | Enable UI HTTPRoute (Gateway API) |
| ui.httpRoute.hostnames | list | `["apptrail.local"]` | Hostnames to match |
| ui.httpRoute.parentRefs | list | `[]` | Parent gateway references |
| ui.httpRoute.rules | list | `[{"matches":[{"path":{"type":"PathPrefix","value":"/"}}]}]` | HTTPRoute rules (backendRefs auto-set to UI service if omitted) |
| ui.image.pullPolicy | string | `"IfNotPresent"` | Image pull policy |
| ui.image.repository | string | `"ghcr.io/apptrail-sh/ui"` | Container image repository |
| ui.image.tag | string | `""` | Image tag (users must set this; no appVersion fallback for UI) |
| ui.ingress.annotations | object | `{}` | Ingress annotations |
| ui.ingress.className | string | `""` | Ingress class name |
| ui.ingress.enabled | bool | `false` | Enable UI ingress |
| ui.ingress.hosts | list | `[{"host":"apptrail.local","paths":[{"path":"/","pathType":"Prefix"}]}]` | Ingress hosts |
| ui.ingress.tls | list | `[]` | Ingress TLS configuration |
| ui.livenessProbe.httpGet.path | string | `"/health"` |  |
| ui.livenessProbe.httpGet.port | string | `"http"` |  |
| ui.livenessProbe.initialDelaySeconds | int | `5` |  |
| ui.livenessProbe.periodSeconds | int | `15` |  |
| ui.nodeSelector | object | `{}` | Node selector |
| ui.podAnnotations | object | `{}` | Pod annotations |
| ui.podLabels | object | `{}` | Pod labels |
| ui.podSecurityContext.runAsNonRoot | bool | `true` |  |
| ui.podSecurityContext.seccompProfile.type | string | `"RuntimeDefault"` |  |
| ui.readinessProbe.httpGet.path | string | `"/health"` |  |
| ui.readinessProbe.httpGet.port | string | `"http"` |  |
| ui.readinessProbe.initialDelaySeconds | int | `3` |  |
| ui.readinessProbe.periodSeconds | int | `10` |  |
| ui.replicaCount | int | `1` | Number of replicas |
| ui.resources | object | `{"limits":{"cpu":"200m","memory":"128Mi"},"requests":{"cpu":"10m","memory":"32Mi"}}` | Resource requests and limits |
| ui.securityContext.allowPrivilegeEscalation | bool | `false` |  |
| ui.securityContext.capabilities.drop[0] | string | `"ALL"` |  |
| ui.securityContext.readOnlyRootFilesystem | bool | `true` |  |
| ui.securityContext.runAsNonRoot | bool | `true` |  |
| ui.securityContext.runAsUser | int | `101` |  |
| ui.service.port | int | `8080` | Service port |
| ui.service.type | string | `"ClusterIP"` | Service type |
| ui.tolerations | list | `[]` | Tolerations |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
