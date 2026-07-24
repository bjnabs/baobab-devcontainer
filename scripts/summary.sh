#!/usr/bin/env bash
# =============================================================================
# summary.sh  (installed in the image as: baobab-summary)
#
# Prints a concise, friendly snapshot of the environment. Runs automatically
# as the devcontainer's postStartCommand, and can be run manually at any
# time. Never fails the container start — all lookups are best-effort.
# =============================================================================
set +e

BOLD='\033[1m'; DIM='\033[2m'; GREEN='\033[1;32m'; CYAN='\033[1;36m'; RESET='\033[0m'

v() { "$@" --version 2>/dev/null | head -n1; }

echo -e "${CYAN}╔══════════════════════════════════════════════════════════════════╗${RESET}"
echo -e "${CYAN}║${RESET}  ${BOLD}BAOBAB Enterprise Platform — Development Container${RESET}                ${CYAN}║${RESET}"
echo -e "${CYAN}╚══════════════════════════════════════════════════════════════════╝${RESET}"

echo -e "\n${BOLD}Runtime${RESET}"
printf "  %-14s %s\n" "OS"       "$(source /etc/os-release 2>/dev/null && echo "$PRETTY_NAME")"
printf "  %-14s %s\n" "User"     "$(whoami) (uid=$(id -u), gid=$(id -g))"
printf "  %-14s %s\n" "Workdir"  "$(pwd)"
printf "  %-14s %s\n" "Image tag" "${BAOBAB_IMAGE_VERSION:-unknown (set BAOBAB_IMAGE_VERSION at build time)}"

echo -e "\n${BOLD}Languages${RESET}"
printf "  %-14s %s\n" "Python"   "$(v python3.14)"
printf "  %-14s %s\n" "Poetry"   "$(v poetry)"
printf "  %-14s %s\n" "Node.js"  "$(v node)"
printf "  %-14s %s\n" "pnpm"     "$(v pnpm)"
printf "  %-14s %s\n" "Flutter"  "$(flutter --version 2>/dev/null | head -n1)"

echo -e "\n${BOLD}Data & Infra clients${RESET}"
printf "  %-14s %s\n" "psql"       "$(v psql)"
printf "  %-14s %s\n" "redis-cli"  "$(redis-cli --version 2>/dev/null)"
printf "  %-14s %s\n" "docker"     "$(docker --version 2>/dev/null)"
printf "  %-14s %s\n" "compose"    "$(docker compose version --short 2>/dev/null)"
printf "  %-14s %s\n" "gh"         "$(gh --version 2>/dev/null | head -n1)"

echo -e "\n${BOLD}Project detection${RESET}"
[ -f pyproject.toml ]   && echo -e "  ${GREEN}✔${RESET} pyproject.toml found — Poetry-managed Python project"
[ -f package.json ]     && echo -e "  ${GREEN}✔${RESET} package.json found — Node project"
[ -f pubspec.yaml ]     && echo -e "  ${GREEN}✔${RESET} pubspec.yaml found — Flutter project"
[ -f docker-compose.yml ] || [ -f docker-compose.yaml ] || [ -f compose.yaml ] && \
  echo -e "  ${GREEN}✔${RESET} Compose file found — run 'docker compose up -d' for local infra"
if [ ! -f .env ] && [ -f .env.example ]; then
  echo -e "  ${DIM}• .env not found — copy .env.example to .env before running the app${RESET}"
fi

echo -e "\n${BOLD}Useful commands${RESET}"
echo -e "  ${DIM}baobab-verify${RESET}   — full toolchain verification report"
echo -e "  ${DIM}baobab-summary${RESET}  — show this screen again"
echo -e "  ${DIM}dc up -d${RESET}        — alias for 'docker compose up -d'"
echo -e "  ${DIM}djrun${RESET}           — alias for 'python manage.py runserver 0.0.0.0:8000'"
echo ""
