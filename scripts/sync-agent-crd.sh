#!/usr/bin/env bash
#
# sync-agent-crd.sh - Syncs CRD from agent release and bumps chart version
#
# Usage: ./scripts/sync-agent-crd.sh <new-agent-version>
#
# This script is called by Renovate postUpgradeTasks when the agent version changes.
# It:
#   1. Downloads the CRD from the agent release
#   2. Calculates the chart version bump based on agent's semver change
#   3. Updates Chart.yaml with the new chart version
#   4. Regenerates helm-docs
#

set -euo pipefail

CHART_DIR="charts/apptrail-agent"
CHART_FILE="${CHART_DIR}/Chart.yaml"
CRD_FILE="${CHART_DIR}/crds/workloadrolloutstate.yaml"
AGENT_REPO="apptrail-sh/agent"
HELM_DOCS_VERSION="1.14.2"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Parse semver into components
parse_semver() {
    local version="${1#v}"  # Remove 'v' prefix if present
    local major minor patch
    
    IFS='.' read -r major minor patch <<< "$version"
    
    # Handle pre-release versions (e.g., 1.0.0-rc1)
    patch="${patch%%-*}"
    
    echo "$major $minor $patch"
}

# Calculate version bump type between two versions
get_bump_type() {
    local old_version="$1"
    local new_version="$2"
    
    read -r old_major old_minor old_patch <<< "$(parse_semver "$old_version")"
    read -r new_major new_minor new_patch <<< "$(parse_semver "$new_version")"
    
    if [[ "$new_major" -gt "$old_major" ]]; then
        echo "major"
    elif [[ "$new_minor" -gt "$old_minor" ]]; then
        echo "minor"
    else
        echo "patch"
    fi
}

# Bump a semver version
bump_version() {
    local version="$1"
    local bump_type="$2"
    
    read -r major minor patch <<< "$(parse_semver "$version")"
    
    case "$bump_type" in
        major)
            major=$((major + 1))
            minor=0
            patch=0
            ;;
        minor)
            minor=$((minor + 1))
            patch=0
            ;;
        patch)
            patch=$((patch + 1))
            ;;
    esac
    
    echo "${major}.${minor}.${patch}"
}

# Get current values from Chart.yaml
get_chart_value() {
    local key="$1"
    grep "^${key}:" "$CHART_FILE" | sed "s/${key}:[[:space:]]*[\"']*\([^\"']*\)[\"']*/\1/"
}

# Update a value in Chart.yaml
set_chart_value() {
    local key="$1"
    local value="$2"
    
    if [[ "$key" == "appVersion" ]]; then
        # appVersion needs quotes
        sed -i.bak "s/^${key}:.*/${key}: \"${value}\"/" "$CHART_FILE"
    else
        sed -i.bak "s/^${key}:.*/${key}: ${value}/" "$CHART_FILE"
    fi
    rm -f "${CHART_FILE}.bak"
}

# Download CRD from agent release
download_crd() {
    local version="$1"
    local tag="${version}"
    
    # Ensure version has 'v' prefix for GitHub release tag
    [[ "$tag" != v* ]] && tag="v${tag}"
    
    local crd_url="https://github.com/${AGENT_REPO}/releases/download/${tag}/apptrail.apptrail.sh_workloadrolloutstates.yaml"
    local raw_url="https://raw.githubusercontent.com/${AGENT_REPO}/${tag}/config/crd/bases/apptrail.apptrail.sh_workloadrolloutstates.yaml"
    
    log_info "Downloading CRD for agent ${tag}..."
    
    # Try release artifact first, fall back to raw file
    if curl -sfL "$crd_url" -o "$CRD_FILE" 2>/dev/null; then
        log_info "Downloaded CRD from release artifacts"
    elif curl -sfL "$raw_url" -o "$CRD_FILE" 2>/dev/null; then
        log_info "Downloaded CRD from raw GitHub content"
    else
        log_error "Failed to download CRD for version ${tag}"
        return 1
    fi
    
    # Add source annotations
    if command -v yq &> /dev/null; then
        yq -i ".metadata.annotations[\"apptrail.sh/source-version\"] = \"${tag}\"" "$CRD_FILE"
        yq -i ".metadata.annotations[\"apptrail.sh/synced-at\"] = \"$(date -u +%Y-%m-%dT%H:%M:%SZ)\"" "$CRD_FILE"
        log_info "Added source annotations to CRD"
    else
        log_warn "yq not available, skipping source annotations"
    fi
}

main() {
    local new_agent_version="${1:-}"
    
    if [[ -z "$new_agent_version" ]]; then
        log_error "Usage: $0 <new-agent-version>"
        exit 1
    fi
    
    # Remove 'v' prefix for consistency
    new_agent_version="${new_agent_version#v}"
    
    log_info "Syncing agent version ${new_agent_version}"
    
    # Get current versions
    local current_chart_version
    local current_app_version
    current_chart_version=$(get_chart_value "version")
    current_app_version=$(get_chart_value "appVersion")
    
    log_info "Current chart version: ${current_chart_version}"
    log_info "Current app version: ${current_app_version}"
    log_info "New agent version: ${new_agent_version}"
    
    # Download the CRD
    download_crd "$new_agent_version"
    
    # Calculate version bump type based on agent version change
    local bump_type
    bump_type=$(get_bump_type "$current_app_version" "$new_agent_version")
    log_info "Detected ${bump_type} version bump"
    
    # Calculate new chart version
    local new_chart_version
    new_chart_version=$(bump_version "$current_chart_version" "$bump_type")
    
    log_info "Bumping chart version: ${current_chart_version} → ${new_chart_version} (${bump_type})"
    
    # Update Chart.yaml
    set_chart_value "version" "$new_chart_version"
    set_chart_value "appVersion" "$new_agent_version"
    
    # Regenerate helm-docs
    run_helm_docs
    
    log_info "✅ Sync complete!"
    log_info "   Chart version: ${new_chart_version}"
    log_info "   App version: ${new_agent_version}"
    log_info "   CRD updated: ${CRD_FILE}"
}

# Install helm-docs if not available
install_helm_docs() {
    local os arch
    os=$(uname -s | tr '[:upper:]' '[:lower:]')
    arch=$(uname -m)
    
    case "$arch" in
        x86_64) arch="x86_64" ;;
        aarch64|arm64) arch="arm64" ;;
        *) log_error "Unsupported architecture: $arch"; return 1 ;;
    esac
    
    local url="https://github.com/norwoodj/helm-docs/releases/download/v${HELM_DOCS_VERSION}/helm-docs_${HELM_DOCS_VERSION}_${os}_${arch}.tar.gz"
    
    log_info "Installing helm-docs v${HELM_DOCS_VERSION}..."
    
    local tmp_dir
    tmp_dir=$(mktemp -d)
    trap "rm -rf $tmp_dir" EXIT
    
    if curl -sfL "$url" | tar -xz -C "$tmp_dir"; then
        # Try to install to /usr/local/bin, fall back to local bin
        if [[ -w /usr/local/bin ]]; then
            mv "$tmp_dir/helm-docs" /usr/local/bin/
        else
            mkdir -p "$HOME/.local/bin"
            mv "$tmp_dir/helm-docs" "$HOME/.local/bin/"
            export PATH="$HOME/.local/bin:$PATH"
        fi
        log_info "helm-docs installed successfully"
    else
        log_error "Failed to install helm-docs"
        return 1
    fi
}

# Run helm-docs to regenerate documentation
run_helm_docs() {
    if ! command -v helm-docs &> /dev/null; then
        log_warn "helm-docs not found, attempting to install..."
        install_helm_docs || {
            log_warn "Could not install helm-docs, skipping documentation generation"
            return 0
        }
    fi
    
    log_info "Regenerating helm-docs..."
    helm-docs --chart-search-root=charts
    log_info "helm-docs regenerated"
}

main "$@"

