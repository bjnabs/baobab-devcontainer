# 20-aliases.sh — useful aliases for the BAOBAB devcontainer
# shellcheck shell=bash

# Modern replacements for classic tools (fall back gracefully if not present)
command -v eza >/dev/null 2>&1 && alias ls='eza --group-directories-first' && alias ll='eza -alh --group-directories-first' && alias lt='eza --tree --level=2'
command -v bat >/dev/null 2>&1 && alias cat='bat --paging=never'
command -v fd  >/dev/null 2>&1 && alias find='fd'
command -v rg  >/dev/null 2>&1 && alias grep='rg'

alias ..='cd ..'
alias ...='cd ../..'
alias c='clear'
alias h='history'

# Django / BAOBAB shortcuts
alias dj='python manage.py'
alias djrun='python manage.py runserver 0.0.0.0:8000'
alias djmig='python manage.py makemigrations && python manage.py migrate'
alias djtenant='python manage.py migrate_schemas'
alias djshell='python manage.py shell'

# Celery
alias celeryworker='celery -A config worker -l info'
alias celerybeat='celery -A config beat -l info'

# Docker Compose
alias dc='docker compose'
alias dcu='docker compose up -d'
alias dcd='docker compose down'
alias dcl='docker compose logs -f'
alias dcps='docker compose ps'

# Poetry
alias pin='poetry install'
alias prun='poetry run'
alias pshell='poetry shell'

# Node / frontend
alias ni='pnpm install'
alias nd='pnpm dev'
alias nb='pnpm build'

# Flutter
alias fldr='flutter doctor'
alias flr='flutter run'
alias flpg='flutter pub get'

# Git
alias gs='git status'
alias gp='git pull --rebase'
alias gl='git log --oneline --graph --decorate -n 20'
