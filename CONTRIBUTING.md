# Contributing to AppTrail Helm Charts

Thank you for your interest in contributing to AppTrail Helm Charts!

## Development Workflow

### Prerequisites

Install the following tools:

- [Helm](https://helm.sh/docs/intro/install/) v3.x
- [helm-docs](https://github.com/norwoodj/helm-docs) for generating documentation
- [chart-testing (ct)](https://github.com/helm/chart-testing) for linting and testing
- [kind](https://kind.sigs.k8s.io/) for local Kubernetes clusters
- [kubeconform](https://github.com/yannh/kubeconform) for manifest validation

### Making Changes

1. **Fork and clone** the repository

2. **Create a branch** for your changes:
   ```bash
   git checkout -b feat/my-feature
   ```

3. **Make your changes** to the chart(s) in `charts/`

4. **Bump the version** in `Chart.yaml`:
   ```yaml
   version: 0.2.0  # Increment appropriately
   ```

5. **Update documentation**:
   ```bash
   helm-docs
   ```

6. **Lint your changes**:
   ```bash
   ct lint --config ct.yaml
   ```

7. **Test locally**:
   ```bash
   kind create cluster --name test
   ct install --config ct.yaml
   kind delete cluster --name test
   ```

8. **Commit and push** your changes

9. **Create a Pull Request**

### Versioning

We follow [Semantic Versioning](https://semver.org/):

- **MAJOR**: Breaking changes to values.yaml or behavior
- **MINOR**: New features, backwards compatible
- **PATCH**: Bug fixes, backwards compatible

### Pull Request Guidelines

- PRs must pass all CI checks (lint, validate, test)
- Include a clear description of changes
- Update documentation if adding new values
- One chart change per PR when possible

### Chart Guidelines

#### Values

- Use clear, descriptive names
- Document all values with comments
- Provide sensible defaults
- Use `# --` prefix for helm-docs annotations

#### Templates

- Follow Helm best practices
- Include proper labels and annotations
- Support common configurations (resources, nodeSelector, tolerations, affinity)
- Use helper templates in `_helpers.tpl`

#### Security

- Set secure defaults (runAsNonRoot, readOnlyRootFilesystem, etc.)
- Drop all capabilities by default
- Use securityContext appropriately

## Questions?

Open an issue for questions or discussion.

