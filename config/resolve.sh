#!/usr/bin/env bash
# ==============================================================================
# BAOBAB Enterprise Platform
# Version Resolver
#
# File: config/resolve.sh
#
# Purpose:
#   Reads config/versions.yaml and generates config/versions.lock.
#
# Requirements:
#   - bash
#   - yq v4+
#   - curl
#
# Usage:
#   ./config/resolve.sh
#
# ==============================================================================

set -Eeuo pipefail

# ------------------------------------------------------------------------------
# Directories
# ------------------------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

MANIFEST="${SCRIPT_DIR}/versions.yaml"
LOCKFILE="${SCRIPT_DIR}/versions.lock"

# ------------------------------------------------------------------------------
# Logging
# ------------------------------------------------------------------------------

info() {
    printf "[INFO] %s\n" "$*"
}

warn() {
    printf "[WARN] %s\n" "$*" >&2
}

error() {
    printf "[ERROR] %s\n" "$*" >&2
}

die() {
    error "$*"
    exit 1
}

# ------------------------------------------------------------------------------
# Checks
# ------------------------------------------------------------------------------

command -v yq >/dev/null 2>&1 \
    || die "yq is not installed."

command -v curl >/dev/null 2>&1 \
    || die "curl is not installed."

[[ -f "$MANIFEST" ]] \
    || die "Cannot find ${MANIFEST}"

# ------------------------------------------------------------------------------
# Helper functions
# ------------------------------------------------------------------------------

yaml() {
    yq -r "$1" "$MANIFEST"
}

github_latest() {

    local repo="$1"

    curl -fsSL \
        ${GITHUB_TOKEN:+-H "Authorization: Bearer ${GITHUB_TOKEN}"} \
        "https://api.github.com/repos/${repo}/releases/latest" |
        yq -r '.tag_name' |
        sed 's/^v//'
}

flutter_latest() {

    curl -fsSL \
        "https://storage.googleapis.com/flutter_infra_release/releases/releases_linux.json" |
        yq -r '
            .current_release.stable as $stable
            | .releases[]
            | select(.hash==$stable)
            | .version
        '
}

# ------------------------------------------------------------------------------
# Read versions
# ------------------------------------------------------------------------------

PYTHON_VERSION=$(yaml '.languages.python.version')

NODE_MAJOR=$(yaml '.languages.node.major')

POSTGRES_MAJOR=$(yaml '.database.postgresql.major')

# ------------------------------------------------------------------------------
# Flutter
# ------------------------------------------------------------------------------

FLUTTER_VERSION=$(yaml '.languages.flutter.version')

if [[ "$FLUTTER_VERSION" == "latest" ]]; then
    info "Resolving latest Flutter release..."
    FLUTTER_VERSION=$(flutter_latest)
fi

# ------------------------------------------------------------------------------
# GitHub tools
# ------------------------------------------------------------------------------

resolve_github() {

    local yaml_path="$1"
    local repo="$2"

    local version

    version=$(yaml "$yaml_path")

    if [[ "$version" == "latest" ]]; then
        info "Resolving ${repo}..."
        github_latest "$repo"
    else
        printf "%s" "$version"
    fi
}

TASK_VERSION=$(resolve_github '.utilities.task.version' 'go-task/task')

RIPGREP_VERSION=$(resolve_github '.utilities.ripgrep.version' 'BurntSushi/ripgrep')

FD_VERSION=$(resolve_github '.utilities.fd.version' 'sharkdp/fd')

BAT_VERSION=$(resolve_github '.utilities.bat.version' 'sharkdp/bat')

EZA_VERSION=$(resolve_github '.utilities.eza.version' 'eza-community/eza')

YQ_VERSION=$(resolve_github '.utilities.yq.version' 'mikefarah/yq')

GH_VERSION=$(resolve_github '.development.github_cli.version' 'cli/cli')

COSIGN_VERSION=$(resolve_github '.security.cosign.version' 'sigstore/cosign')

# ------------------------------------------------------------------------------
# Generate lock file
# ------------------------------------------------------------------------------

cat > "$LOCKFILE" <<EOF
# ==============================================================================
# BAOBAB Version Lock File
#
# Generated automatically by resolve.sh
#
# DO NOT EDIT
# ==============================================================================

export UBUNTU_VERSION=$(yaml '.platform.ubuntu.version')

export PYTHON_VERSION=${PYTHON_VERSION}

export NODE_MAJOR=${NODE_MAJOR}

export FLUTTER_VERSION=${FLUTTER_VERSION}

export POSTGRES_MAJOR=${POSTGRES_MAJOR}

export TASK_VERSION=${TASK_VERSION}

export RIPGREP_VERSION=${RIPGREP_VERSION}

export FD_VERSION=${FD_VERSION}

export BAT_VERSION=${BAT_VERSION}

export EZA_VERSION=${EZA_VERSION}

export YQ_VERSION=${YQ_VERSION}

export GH_VERSION=${GH_VERSION}

export COSIGN_VERSION=${COSIGN_VERSION}

EOF

chmod 644 "$LOCKFILE"

info "Generated ${LOCKFILE}"

echo
cat "$LOCKFILE"
echo

info "Version resolution complete."
