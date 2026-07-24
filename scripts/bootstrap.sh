#!/usr/bin/env bash
# =============================================================================
# bootstrap.sh
#
# One-command onboarding for a new BAOBAB engineer or an automated runner
# that consumes the published ghcr.io/nabhold-group-africa/baobab-devcontainer
# image OUTSIDE of the VS Code / Codespaces devcontainer lifecycle — e.g.:
#   - a bare `docker run` for a GitHub Actions self-hosted job
#   - a fresh Codespace where a developer wants to re-run onboarding by hand
#   - a local machine that has cloned the devcontainer repo directly
#
# This complements (does not replace) .devcontainer/post-create.sh:
#   post-create.sh -> installs THIS repo's language dependencies
#   bootstrap.sh    -> configures the developer's identity, auth, git hooks,
#                      and secrets scaffolding, then delegates dependency
#                      installation to post-create.sh
#
# Usage:
#   ./scripts/bootstrap.sh [--non-interactive]
# =============================================================================
set -euo pipefail

NON_INTERACTIVE=0
for arg in "$@"; do
  case "$arg" in
    --non-interactive) NON_INTERACTIVE=1 ;;
  esac
done

log()  { printf '\n\033[1;36m[bootstrap]\033[0m %s\n' "$1"; }
warn() { printf '\n\033[1;33m[bootstrap] WARNING:\033[0m %s\n' "$1"; }
die()  { printf '\n\033[1;31m[bootstrap] ERROR:\033[0m %s\n' "$1" >&2; exit 1; }

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "${REPO_ROOT}"

# -----------------------------------------------------------------------------
# 1. Sanity-check we're actually on the expected image
# -----------------------------------------------------------------------------
log "Checking toolchain versions"
if command -v baobab-verify >/dev/null 2>&1; then
  baobab-verify --quiet || warn "Toolchain verification reported issues — run 'baobab-verify' for details."
else
  warn "baobab-verify not found. Are you running inside the BAOBAB devcontainer image?"
fi

# -----------------------------------------------------------------------------
# 2. Git identity
# -----------------------------------------------------------------------------
log "Configuring git identity"
git config --global --add safe.directory "${REPO_ROOT}"
if [ "$NON_INTERACTIVE" -eq 0 ] && [ -z "$(git config --global user.name || true)" ]; then
  read -rp "  Git user.name: "  GIT_NAME
  read -rp "  Git user.email: " GIT_EMAIL
  git config --global user.name  "${GIT_NAME}"
  git config --global user.email "${GIT_EMAIL}"
fi
git config --global pull.rebase true
git config --global init.defaultBranch main
git config --global core.editor "code --wait"

# -----------------------------------------------------------------------------
# 3. GitHub CLI authentication
# -----------------------------------------------------------------------------
log "Checking GitHub CLI authentication"
if ! gh auth status >/dev/null 2>&1; then
  if [ -n "${GITHUB_TOKEN:-}" ]; then
    log "Authenticating gh via GITHUB_TOKEN"
    echo "${GITHUB_TOKEN}" | gh auth login --with-token
  elif [ "$NON_INTERACTIVE" -eq 0 ]; then
    log "Launching interactive 'gh auth login' (Codespaces usually pre-authenticates this for you)"
    gh auth login || warn "gh auth login was skipped or failed; some scripts may not work until you authenticate."
  else
    warn "Non-interactive mode with no GITHUB_TOKEN set — skipping gh auth."
  fi
else
  log "gh is already authenticated as $(gh api user --jq .login 2>/dev/null || echo unknown)"
fi

# -----------------------------------------------------------------------------
# 4. Secrets / environment scaffolding
# -----------------------------------------------------------------------------
if [ -f ".env.example" ] && [ ! -f ".env" ]; then
  log "Creating .env from .env.example"
  cp .env.example .env
  warn "Remember to fill in real secrets in .env — it is git-ignored by default."
fi

# -----------------------------------------------------------------------------
# 5. Git hooks (pre-commit)
# -----------------------------------------------------------------------------
if [ -f ".pre-commit-config.yaml" ]; then
  log "Installing pre-commit hooks"
  pipx list 2>/dev/null | grep -q pre-commit || pipx install pre-commit
  pre-commit install --install-hooks
fi

# -----------------------------------------------------------------------------
# 6. Delegate dependency installation to post-create.sh, if present
# -----------------------------------------------------------------------------
if [ -f ".devcontainer/post-create.sh" ]; then
  log "Running .devcontainer/post-create.sh to install project dependencies"
  bash .devcontainer/post-create.sh --stage=on-create
  bash .devcontainer/post-create.sh --stage=post-create
fi

log "Bootstrap complete. Run 'baobab-summary' any time for an environment overview."
