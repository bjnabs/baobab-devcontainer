#!/usr/bin/env bash
# =============================================================================
# verify.sh (installed as: baobab-verify)
#
# Verifies that the BAOBAB development environment is healthy.
#
# Exit codes
#   0 = Success
#   1 = One or more required checks failed
# =============================================================================

set -euo pipefail

###############################################################################
# Options
###############################################################################

QUIET=0

for arg in "$@"; do
    case "$arg" in
        --quiet) QUIET=1 ;;
    esac
done

###############################################################################
# Globals
###############################################################################

PASS=0
FAIL=0
WARN=0

TMP_FLUTTER_LOG="$(mktemp)"
trap 'rm -f "${TMP_FLUTTER_LOG}"' EXIT

###############################################################################
# Locate configuration
###############################################################################

CONFIG_DIR=""

if [[ -n "${BAOBAB_CONFIG_DIR:-}" && -f "${BAOBAB_CONFIG_DIR}/versions.lock" ]]; then
    CONFIG_DIR="${BAOBAB_CONFIG_DIR}"

elif [[ -f "/usr/local/share/baobab/config/versions.lock" ]]; then
    CONFIG_DIR="/usr/local/share/baobab/config"

elif [[ -f "./config/versions.lock" ]]; then
    CONFIG_DIR="./config"
fi

if [[ -n "${CONFIG_DIR}" ]]; then
    # shellcheck disable=SC1091
    source "${CONFIG_DIR}/versions.lock"
fi

###############################################################################
# Defaults (fallback)
###############################################################################

: "${PYTHON_MINOR:=3.14}"
: "${PYTHON_VERSION:=3.14}"
: "${NODE_MAJOR:=24}"
: "${FLUTTER_VERSION:=unknown}"
: "${EXPECTED_USER:=vscode}"
: "${EXPECTED_UID:=1000}"
: "${EXPECTED_GID:=1000}"

###############################################################################
# Output helpers
###############################################################################

say() {
    [[ "$QUIET" -eq 0 ]] && printf '%b\n' "$1"
}

ok() {
    PASS=$((PASS+1))
    say "  \033[1;32m✔\033[0m $1"
}

bad() {
    FAIL=$((FAIL+1))
    printf '  \033[1;31m✘\033[0m %s\n' "$1"
}

warnc() {
    WARN=$((WARN+1))
    [[ "$QUIET" -eq 0 ]] && printf '  \033[1;33m•\033[0m %s\n' "$1"
}

section() {
    say ""
    say "\033[1m$1\033[0m"
}

###############################################################################
# Helpers
###############################################################################

check_required() {

    local label="$1"
    local cmd="$2"
    local version_cmd="${3:-$2 --version}"

    if command -v "$cmd" >/dev/null 2>&1; then
        local version

        version="$(
            bash -c "$version_cmd" 2>/dev/null \
            | head -n1
        )"

        ok "$label (${version})"

    else
        bad "$label — '$cmd' not found"
    fi
}

check_optional() {

    local label="$1"
    local cmd="$2"
    local version_cmd="${3:-$2 --version}"

    if command -v "$cmd" >/dev/null 2>&1; then

        local version

        version="$(
            bash -c "$version_cmd" 2>/dev/null \
            | head -n1
        )"

        ok "$label (${version})"

    else

        warnc "$label not installed"

    fi
}

###############################################################################
# Header
###############################################################################

say ""
say "\033[1mBAOBAB Development Environment Verification\033[0m"

if [[ -f "${CONFIG_DIR:-}/versions.lock" ]]; then
    say "Configuration : ${CONFIG_DIR}/versions.lock"
else
    say "Configuration : built-in defaults"
fi

###############################################################################
# Core
###############################################################################

section "Core System"

check_required "git" git
check_required "curl" curl
check_required "jq" jq
check_required "sudo" sudo

###############################################################################
# Python
###############################################################################

section "Python"

check_required \
    "Python ${PYTHON_VERSION}" \
    "python${PYTHON_MINOR}" \
    "python${PYTHON_MINOR} --version"

check_required "pip" pip3
check_required "pipx" pipx
check_required "uv" uv
check_required "Poetry" poetry

if command -v poetry >/dev/null; then

    if [[ "$(poetry config virtualenvs.in-project)" == "true" ]]; then
        ok "Poetry configured for in-project virtualenvs"
    else
        warnc "Poetry virtualenvs.in-project=false"
    fi

fi

###############################################################################
# JavaScript
###############################################################################

section "JavaScript"

check_required "Node.js ${NODE_MAJOR}" node
check_required "npm" npm
check_required "pnpm" pnpm
check_optional "Yarn" yarn

###############################################################################
# Flutter
###############################################################################

section "Flutter"

check_required "Flutter" flutter
check_required "Dart" dart

if [[ "$QUIET" -eq 0 ]] && command -v flutter >/dev/null; then

    flutter doctor --no-version-check >"${TMP_FLUTTER_LOG}" 2>&1 || true

    if grep -q "No issues found" "${TMP_FLUTTER_LOG}"; then
        ok "flutter doctor reports healthy environment"
    else
        warnc "flutter doctor reports warnings"
    fi

fi

###############################################################################
# Databases
###############################################################################

section "Database"

check_required "PostgreSQL client" psql
check_required "Redis CLI" redis-cli

###############################################################################
# Docker
###############################################################################

section "Containers"

check_required "Docker CLI" docker

if command -v docker >/dev/null; then

    if docker compose version >/dev/null 2>&1; then
        ok "Docker Compose plugin"
    else
        bad "Docker Compose plugin missing"
    fi

    if docker info >/dev/null 2>&1; then
        ok "Docker daemon reachable"
    else
        warnc "Docker daemon unavailable"
    fi

fi

###############################################################################
# GitHub
###############################################################################

section "GitHub"

check_required "GitHub CLI" gh

if command -v gh >/dev/null; then

    if gh auth status >/dev/null 2>&1; then
        ok "GitHub authentication"
    else
        warnc "GitHub CLI not authenticated"
    fi

fi

###############################################################################
# Utilities
###############################################################################

section "Utilities"

check_required "ripgrep" rg
check_required "fd" fd
check_required "bat" bat
check_required "eza" eza
check_required "fzf" fzf
check_optional "tmux" tmux

###############################################################################
# User
###############################################################################

section "User"

[[ "$(id -u)" == "${EXPECTED_UID}" ]] \
    && ok "UID ${EXPECTED_UID}" \
    || bad "Expected UID ${EXPECTED_UID}, got $(id -u)"

[[ "$(id -g)" == "${EXPECTED_GID}" ]] \
    && ok "GID ${EXPECTED_GID}" \
    || bad "Expected GID ${EXPECTED_GID}, got $(id -g)"

[[ "$(whoami)" == "${EXPECTED_USER}" ]] \
    && ok "User ${EXPECTED_USER}" \
    || bad "Expected user ${EXPECTED_USER}, got $(whoami)"

sudo -n true >/dev/null 2>&1 \
    && ok "Passwordless sudo" \
    || bad "Passwordless sudo unavailable"

###############################################################################
# Summary
###############################################################################

say ""
say "------------------------------------------------"

say "Passed   : ${PASS}"
say "Warnings : ${WARN}"
say "Failed   : ${FAIL}"

if [[ "$FAIL" -eq 0 ]]; then

    say ""
    say "\033[1;32mEnvironment Status : HEALTHY\033[0m"

    exit 0

else

    say ""
    say "\033[1;31mEnvironment Status : FAILED\033[0m"

    exit 1

fi
