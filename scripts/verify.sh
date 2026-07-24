#!/usr/bin/env bash
# =============================================================================
# verify.sh  (installed in the image as: baobab-verify)
#
# Validates that every tool BAOBAB developers depend on is installed, on
# PATH, and executes without error. Intended to be run:
#   - automatically during post-create.sh (via --quiet)
#   - manually by a developer troubleshooting their environment
#   - as a CI smoke test right after `docker build`, before publishing
#
# Exit code: 0 if everything required passed, 1 if any REQUIRED check failed.
# Optional tools that are missing only produce a warning, not a failure.
# =============================================================================
set -uo pipefail

QUIET=0
for arg in "$@"; do
  case "$arg" in
    --quiet) QUIET=1 ;;
  esac
done

PASS=0
FAIL=0
WARN=0

say()  { [ "$QUIET" -eq 0 ] && printf '%b\n' "$1" || true; }
ok()   { PASS=$((PASS+1)); say "  \033[1;32m✔\033[0m $1"; }
bad()  { FAIL=$((FAIL+1)); say "  \033[1;31m✘\033[0m $1"; }
warnc(){ WARN=$((WARN+1)); say "  \033[1;33m•\033[0m $1"; }

check_required() {
  local label="$1" cmd="$2"
  if command -v "$cmd" >/dev/null 2>&1; then
    ok "$label ($("$cmd" --version 2>&1 | head -n1))"
  else
    bad "$label — '$cmd' not found on PATH"
  fi
}

check_optional() {
  local label="$1" cmd="$2"
  if command -v "$cmd" >/dev/null 2>&1; then
    ok "$label ($("$cmd" --version 2>&1 | head -n1))"
  else
    warnc "$label — '$cmd' not found (optional)"
  fi
}

say "\033[1mBAOBAB devcontainer — environment verification\033[0m"

say "\n\033[1mCore system\033[0m"
check_required "git"        git
check_required "curl"       curl
check_required "jq"         jq
check_required "sudo"       sudo

say "\n\033[1mPython toolchain\033[0m"
check_required "Python 3.14"  python3.14
check_required "pip"          pip3
check_required "pipx"         pipx
check_required "uv"           uv
check_required "Poetry"       poetry
if command -v poetry >/dev/null 2>&1; then
  [ "$(poetry config virtualenvs.in-project)" = "true" ] \
    && ok "Poetry configured for in-project virtualenvs" \
    || warnc "Poetry virtualenvs.in-project is not 'true'"
fi

say "\n\033[1mJavaScript toolchain\033[0m"
check_required "Node.js" node
check_required "npm"     npm
check_required "pnpm"    pnpm
check_required "yarn"    yarn

say "\n\033[1mFlutter / Dart\033[0m"
check_required "Flutter" flutter
check_required "Dart"    dart
if command -v flutter >/dev/null 2>&1; then
  flutter doctor --no-version-check >/tmp/flutter-doctor.log 2>&1
  if grep -q "No issues found" /tmp/flutter-doctor.log; then
    ok "flutter doctor reports no issues"
  else
    warnc "flutter doctor reports issues (expected: no mobile SDKs in this image — see README). Full log: /tmp/flutter-doctor.log"
  fi
fi

say "\n\033[1mDatabase clients\033[0m"
check_required "psql (PostgreSQL client)" psql
check_required "redis-cli"                redis-cli

say "\n\033[1mContainers\033[0m"
check_required "docker CLI"      docker
if docker compose version >/dev/null 2>&1; then
  ok "docker compose plugin ($(docker compose version --short 2>/dev/null))"
else
  bad "docker compose plugin not available"
fi
if docker info >/dev/null 2>&1; then
  ok "Docker daemon reachable (via mounted socket)"
else
  warnc "Docker daemon not reachable — expected until the container is started with the socket mounted (see devcontainer.json)"
fi

say "\n\033[1mGitHub\033[0m"
check_required "GitHub CLI" gh

say "\n\033[1mShell utilities\033[0m"
check_required "ripgrep (rg)" rg
check_required "fd"           fd
check_required "bat"          bat
check_required "eza"          eza
check_required "fzf"          fzf
check_required "tmux"         tmux

say "\n\033[1mUser / permissions\033[0m"
[ "$(id -u)" = "1000" ] && ok "Running as UID 1000" || bad "Expected UID 1000, got $(id -u)"
[ "$(id -g)" = "1000" ] && ok "Running as GID 1000" || bad "Expected GID 1000, got $(id -g)"
[ "$(whoami)" = "vscode" ] && ok "Running as user 'vscode'" || bad "Expected user 'vscode', got $(whoami)"
sudo -n true 2>/dev/null && ok "Passwordless sudo works" || bad "Passwordless sudo failed"

say "\n\033[1mResult:\033[0m \033[1;32m${PASS} passed\033[0m, \033[1;33m${WARN} warnings\033[0m, \033[1;31m${FAIL} failed\033[0m"

if [ "$FAIL" -gt 0 ]; then
  exit 1
fi
exit 0
