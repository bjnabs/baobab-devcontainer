#!/usr/bin/env bash
# =============================================================================
# post-create.sh
#
# Runs inside the running container as the `vscode` user, via devcontainer.json
# lifecycle hooks. It is intentionally split into two stages:
#
#   --stage=on-create    Runs once, right after the container is created
#                         (before the workspace is fully mounted in some
#                         Codespaces prebuild scenarios). Cheap, idempotent,
#                         infra-only steps go here so Codespaces "prebuilds"
#                         can cache them.
#   --stage=post-create   Runs after the workspace source is available.
#                         Installs THIS repository's actual dependencies
#                         (Poetry/pnpm/Flutter), so the base image itself
#                         stays framework-version-agnostic.
#
# Safe to re-run: every step is idempotent and skips work that's already done.
# =============================================================================
set -euo pipefail

STAGE="post-create"
for arg in "$@"; do
  case "$arg" in
    --stage=*) STAGE="${arg#*=}" ;;
  esac
done

WORKSPACE_DIR="${PWD}"
log() { printf '\n\033[1;36m[post-create:%s]\033[0m %s\n' "$STAGE" "$1"; }

# -----------------------------------------------------------------------------
# Stage: on-create — infra warmup only, no project code required
# -----------------------------------------------------------------------------
run_on_create() {
  log "Verifying toolchain (see 'baobab-verify' for the full report)"
  baobab-verify --quiet || log "WARNING: one or more tools failed verification; run 'baobab-verify' for details."

  log "Priming git configuration defaults"
  git config --global --get user.name  >/dev/null 2>&1 || git config --global user.name  "BAOBAB Developer"
  git config --global --get user.email >/dev/null 2>&1 || git config --global user.email "dev@example.com"
  git config --global pull.rebase true
  git config --global init.defaultBranch main
  git config --global --add safe.directory "${WORKSPACE_DIR}"

  log "Priming Poetry / pip caches"
  poetry config virtualenvs.in-project true
}

# -----------------------------------------------------------------------------
# Stage: post-create — project-specific dependency installation
# -----------------------------------------------------------------------------
run_post_create() {
  cd "${WORKSPACE_DIR}"

  if [ -f "pyproject.toml" ]; then
    log "Found pyproject.toml — installing Python dependencies with Poetry"
    poetry env use "$(command -v python3.14)"
    poetry install --no-interaction --no-ansi
  elif [ -f "requirements.txt" ]; then
    log "Found requirements.txt — installing with uv"
    uv venv .venv
    # shellcheck disable=SC1091
    source .venv/bin/activate
    uv pip install -r requirements.txt
  else
    log "No Python dependency manifest found at repo root — skipping Python install."
  fi

  if [ -f "package.json" ]; then
    log "Found package.json — installing JS dependencies"
    if [ -f "pnpm-lock.yaml" ]; then
      pnpm install --frozen-lockfile
    elif [ -f "yarn.lock" ]; then
      yarn install --immutable
    else
      npm ci || npm install
    fi
  else
    log "No package.json found at repo root — skipping JS install."
  fi

  if [ -f "pubspec.yaml" ]; then
    log "Found pubspec.yaml — running flutter pub get"
    flutter pub get
  else
    log "No pubspec.yaml found at repo root — skipping Flutter install."
  fi

  # Multi-package-manager monorepo support: BAOBAB's frontend / mobile
  # packages may live in subdirectories rather than the repo root.
  if [ -d "frontend" ] && [ -f "frontend/package.json" ] && [ ! -f "package.json" ]; then
    log "Found frontend/package.json — installing"
    (cd frontend && { [ -f pnpm-lock.yaml ] && pnpm install --frozen-lockfile || npm install; })
  fi
  if [ -d "mobile" ] && [ -f "mobile/pubspec.yaml" ]; then
    log "Found mobile/pubspec.yaml — running flutter pub get"
    (cd mobile && flutter pub get)
  fi

  if [ -f "docker-compose.yml" ] || [ -f "docker-compose.yaml" ] || [ -f "compose.yaml" ]; then
    log "Compose file detected. Bring up local infra with: docker compose up -d"
  fi

  if [ -f ".env.example" ] && [ ! -f ".env" ]; then
    log "Creating .env from .env.example (fill in secrets before running the app)"
    cp .env.example .env
  fi

  log "post-create complete."
  baobab-summary
}

case "$STAGE" in
  on-create)   run_on_create ;;
  post-create) run_post_create ;;
  *) echo "Unknown stage: $STAGE" >&2; exit 1 ;;
esac
