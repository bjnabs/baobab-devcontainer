# 30-history-and-completion.sh
# shellcheck shell=bash

# --- History improvements -----------------------------------------------
export HISTSIZE=100000
export HISTFILESIZE=200000
export HISTCONTROL=ignoreboth:erasedups   # skip dupes and leading-space cmds
export HISTTIMEFORMAT="%F %T  "
shopt -s histappend                        # append, don't overwrite, on exit
shopt -s cmdhist                           # multi-line commands as one entry
PROMPT_COMMAND="history -a; history -c; history -r; ${PROMPT_COMMAND:-}"

# --- Completion ------------------------------------------------------------
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Git completion ships with bash-completion on Ubuntu (git-core sets it up);
# fall back to fetching it if it's ever missing from the base image.
if ! type _git >/dev/null 2>&1 && [ -f /usr/share/bash-completion/completions/git ]; then
  . /usr/share/bash-completion/completions/git
fi

# gh, docker, and poetry ship their own completion generators.
command -v gh >/dev/null 2>&1 && eval "$(gh completion -s bash)" 2>/dev/null
command -v docker >/dev/null 2>&1 && . <(docker completion bash 2>/dev/null) 2>/dev/null
command -v poetry >/dev/null 2>&1 && eval "$(poetry completions bash)" 2>/dev/null

shopt -s checkwinsize
shopt -s globstar 2>/dev/null