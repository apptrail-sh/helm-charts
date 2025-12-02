# controlplane

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.2.3](https://img.shields.io/badge/AppVersion-0.2.3-informational?style=flat-square)

AppTrail Control Plane - API server for aggregating and querying workload version data

**Homepage:** <https://github.com/apptrail-sh/helm-charts>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| AppTrail |  | <https://github.com/apptrail-sh> |

## Source Code

* <https://github.com/apptrail-sh/controlplane>
* <https://github.com/apptrail-sh/frontend>

## Requirements

Kubernetes: `>=1.26.0-0`

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | Affinity rules |
| autoscaling.enabled | bool | `false` |  |
| autoscaling.maxReplicas | int | `10` |  |
| autoscaling.minReplicas | int | `1` |  |
| autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| config.databaseMaxIdle | int | `5` | Database max idle connections |
| config.databaseMaxOpen | int | `25` | Database max open connections |
| config.httpEventHandler | bool | `true` | Enable HTTP event handler for receiving events from agents |
| config.port | string | `"3000"` | Server port |
| config.teamLabelKey | string | `"team"` | Team label key for workload identification |
| database.existingSecret | string | `""` | Use existing secret for database URL |
| database.existingSecretKey | string | `"database-url"` | Key in existing secret containing database URL |
| database.url | string | `""` | Database URL (required) Format: postgres://user:password@host:port/database?sslmode=disable |
| environmentMapping.configMapKey | string | `"environment-mapping.yaml"` | Key in ConfigMap containing the YAML config |
| environmentMapping.configMapName | string | `""` | Name of ConfigMap containing environment mapping |
| environmentMapping.enabled | bool | `false` | Enable environment mapping from ConfigMap |
| environmentMapping.inline | object | `{}` | Inline environment mapping configuration (alternative to ConfigMap) Example: inline:   cluster_mappings:     production.prod01: production     staging.stg01: staging   namespace_mappings:     default: default |
| extraEnv | list | `[]` | Extra environment variables |
| frontend.affinity | object | `{}` | Frontend affinity rules |
| frontend.appVersion | string | `"0.1.0"` | Frontend application version (REQUIRED) |
| frontend.autoscaling.enabled | bool | `false` |  |
| frontend.autoscaling.maxReplicas | int | `10` |  |
| frontend.autoscaling.minReplicas | int | `1` |  |
| frontend.autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| frontend.enabled | bool | `true` | Enable the frontend web UI |
| frontend.extraEnv | list | `[]` | Extra environment variables for frontend |
| frontend.httpRoute.annotations | object | `{}` |  |
| frontend.httpRoute.enabled | bool | `false` |  |
| frontend.httpRoute.hostnames[0] | string | `"apptrail.local"` |  |
| frontend.httpRoute.parentRefs[0].name | string | `"gateway"` |  |
| frontend.httpRoute.parentRefs[0].sectionName | string | `"http"` |  |
| frontend.httpRoute.rules[0].matches[0].path.type | string | `"PathPrefix"` |  |
| frontend.httpRoute.rules[0].matches[0].path.value | string | `"/"` |  |
| frontend.image.pullPolicy | string | `"IfNotPresent"` | Frontend image pull policy |
| frontend.image.repository | string | `"ghcr.io/apptrail-sh/frontend"` | Frontend container image repository |
| frontend.image.tag | string | `""` | Frontend image tag (defaults to frontend.appVersion) |
| frontend.ingress.annotations | object | `{}` |  |
| frontend.ingress.className | string | `""` |  |
| frontend.ingress.enabled | bool | `false` |  |
| frontend.ingress.hosts[0].host | string | `"apptrail.local"` |  |
| frontend.ingress.hosts[0].paths[0].path | string | `"/"` |  |
| frontend.ingress.hosts[0].paths[0].pathType | string | `"Prefix"` |  |
| frontend.ingress.tls | list | `[]` |  |
| frontend.livenessProbe.httpGet.path | string | `"/health"` |  |
| frontend.livenessProbe.httpGet.port | string | `"http"` |  |
| frontend.livenessProbe.initialDelaySeconds | int | `5` |  |
| frontend.livenessProbe.periodSeconds | int | `10` |  |
| frontend.nodeSelector | object | `{}` | Frontend node selector |
| frontend.podAnnotations | object | `{}` | Frontend pod annotations |
| frontend.podLabels | object | `{}` | Frontend pod labels |
| frontend.podSecurityContext.runAsNonRoot | bool | `true` |  |
| frontend.podSecurityContext.seccompProfile.type | string | `"RuntimeDefault"` |  |
| frontend.readinessProbe.httpGet.path | string | `"/health"` |  |
| frontend.readinessProbe.httpGet.port | string | `"http"` |  |
| frontend.readinessProbe.initialDelaySeconds | int | `3` |  |
| frontend.readinessProbe.periodSeconds | int | `5` |  |
| frontend.replicaCount | int | `1` | Number of frontend replicas |
| frontend.resources | object | `{"limits":{"cpu":"100m","memory":"128Mi"},"requests":{"cpu":"10m","memory":"32Mi"}}` | Frontend resource requests and limits |
| frontend.securityContext.allowPrivilegeEscalation | bool | `false` |  |
| frontend.securityContext.capabilities.drop[0] | string | `"ALL"` |  |
| frontend.securityContext.readOnlyRootFilesystem | bool | `true` |  |
| frontend.securityContext.runAsNonRoot | bool | `true` |  |
| frontend.securityContext.runAsUser | int | `101` |  |
| frontend.service.port | int | `80` |  |
| frontend.service.type | string | `"ClusterIP"` |  |
| frontend.tolerations | list | `[]` | Frontend tolerations |
| fullnameOverride | string | `""` | Override the full resource name |
| httpRoute.annotations | object | `{}` |  |
| httpRoute.enabled | bool | `false` |  |
| httpRoute.hostnames[0] | string | `"api.apptrail.local"` |  |
| httpRoute.parentRefs[0].name | string | `"gateway"` |  |
| httpRoute.parentRefs[0].sectionName | string | `"http"` |  |
| httpRoute.rules[0].matches[0].path.type | string | `"PathPrefix"` |  |
| httpRoute.rules[0].matches[0].path.value | string | `"/"` |  |
| image.pullPolicy | string | `"IfNotPresent"` | Image pull policy |
| image.repository | string | `"ghcr.io/apptrail-sh/controlplane"` | Container image repository |
| image.tag | string | `""` | Overrides the image tag (default: chart appVersion) |
| imagePullSecrets | list | `[]` | Image pull secrets for private registries |
| ingress.annotations | object | `{}` |  |
| ingress.className | string | `""` |  |
| ingress.enabled | bool | `false` |  |
| ingress.hosts[0].host | string | `"api.apptrail.local"` |  |
| ingress.hosts[0].paths[0].path | string | `"/"` |  |
| ingress.hosts[0].paths[0].pathType | string | `"Prefix"` |  |
| ingress.tls | list | `[]` |  |
| livenessProbe.httpGet.path | string | `"/health"` |  |
| livenessProbe.httpGet.port | string | `"http"` |  |
| livenessProbe.initialDelaySeconds | int | `10` |  |
| livenessProbe.periodSeconds | int | `15` |  |
| migrations.enabled | bool | `false` | Enable database migrations init container |
| migrations.extraEnv | list | `[]` | Extra environment variables for migrations |
| migrations.image.pullPolicy | string | `"IfNotPresent"` | Image pull policy |
| migrations.image.repository | string | `"ghcr.io/apptrail-sh/controlplane-migrations"` | Migrations image repository (contains Flyway + SQL migrations) |
| migrations.image.tag | string | `""` | Migrations image tag (defaults to chart appVersion) |
| migrations.jdbcDatabase | string | `"apptrail"` | JDBC database name |
| migrations.jdbcHost | string | `"postgresql"` | JDBC host (PostgreSQL service name) |
| migrations.jdbcParams | string | `"?sslmode=disable"` | JDBC connection params |
| migrations.jdbcPort | string | `"5432"` | JDBC port |
| migrations.password | string | `""` | Database password (required when migrations.enabled and not using existingSecret) |
| migrations.passwordKey | string | `"password"` | Secret key for password (when using database.existingSecret) |
| migrations.resources | object | `{"limits":{"cpu":"200m","memory":"256Mi"},"requests":{"cpu":"50m","memory":"128Mi"}}` | Resource requests and limits for migrations |
| migrations.securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"runAsNonRoot":true,"runAsUser":101}` | Security context for migrations container |
| migrations.username | string | `"apptrail"` | Database username |
| migrations.usernameKey | string | `"username"` | Secret key for username (when using database.existingSecret) |
| nameOverride | string | `""` | Override the chart name |
| nodeSelector | object | `{}` | Node selector |
| podAnnotations | object | `{}` | Pod annotations |
| podLabels | object | `{}` | Pod labels |
| podSecurityContext.runAsNonRoot | bool | `true` |  |
| podSecurityContext.seccompProfile.type | string | `"RuntimeDefault"` |  |
| readinessProbe.httpGet.path | string | `"/health"` |  |
| readinessProbe.httpGet.port | string | `"http"` |  |
| readinessProbe.initialDelaySeconds | int | `5` |  |
| readinessProbe.periodSeconds | int | `10` |  |
| replicaCount | int | `1` | Number of replicas |
| resources | object | `{"limits":{"cpu":"500m","memory":"256Mi"},"requests":{"cpu":"50m","memory":"128Mi"}}` | Resource requests and limits |
| securityContext.allowPrivilegeEscalation | bool | `false` |  |
| securityContext.capabilities.drop[0] | string | `"ALL"` |  |
| securityContext.readOnlyRootFilesystem | bool | `true` |  |
| securityContext.runAsNonRoot | bool | `true` |  |
| securityContext.runAsUser | int | `65532` |  |
| service.port | int | `3000` |  |
| service.type | string | `"ClusterIP"` |  |
| serviceAccount.annotations | object | `{}` | Annotations for the service account |
| serviceAccount.automount | bool | `true` | Automount API credentials |
| serviceAccount.create | bool | `true` | Create a service account |
| serviceAccount.name | string | `""` | Service account name (auto-generated if not set) |
| tolerations | list | `[]` | Tolerations |
| volumeMounts | list | `[]` | Additional volume mounts |
| volumes | list | `[]` | Additional volumes |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
