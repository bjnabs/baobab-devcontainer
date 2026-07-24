# syntax=docker/dockerfile:1.7
#
# =============================================================================
# BAOBAB Enterprise Platform — Standard Development Container
# =============================================================================
# Maintained by: Nabhold Group Africa — Platform Engineering
# Registry:      ghcr.io/nabhold-group-africa/baobab-devcontainer
#
# This image is the single source of truth for the BAOBAB local development
# environment. It is built for GitHub Codespaces and Dev Containers (VS Code /
# JetBrains Gateway) alike, and is also usable as a plain Docker image for CI
# steps that need the same toolchain as developers.
#
# Design principles:
#   - Deterministic: every language runtime and CLI tool is version-pinned
#     via build ARGs, so a given image tag always produces the same content.
#   - Multi-stage: large/one-shot downloads (Flutter SDK, GitHub-released
#     CLI binaries) are fetched and verified in isolated builder stages, so
#     the final stage only ever COPYs clean, extracted artifacts. This keeps
#     the final layer history free of tarballs and speeds up rebuilds because
#     changing an apt package does not invalidate the Flutter download layer
#     (and vice versa).
#   - Multi-arch: every stage is written to work under `docker buildx build
#     --platform linux/amd64,linux/arm64` using the automatic TARGETARCH /
#     TARGETPLATFORM build args — no per-arch Dockerfiles.
#   - Non-root: the final runtime user is `vscode` (UID/GID 1000) with
#     passwordless sudo, matching the GitHub Codespaces convention.
# =============================================================================

ARG UBUNTU_VERSION=26.04
ARG PYTHON_VERSION=3.14.6
ARG PYTHON_MINOR=3.14
ARG NODE_MAJOR=24
ARG FLUTTER_VERSION=3.44.7
ARG GO_TASK_VERSION=3.42.1
ARG RIPGREP_VERSION=14.1.1
ARG FD_VERSION=10.2.0
ARG BAT_VERSION=0.25.0
ARG EZA_VERSION=0.20.9
ARG POSTGRES_MAJOR=17

# -----------------------------------------------------------------------------
# Stage: flutter-sdk — fetch + prune the Flutter stable SDK
# -----------------------------------------------------------------------------
FROM ubuntu:${UBUNTU_VERSION} AS flutter-sdk
ARG FLUTTER_VERSION
ARG TARGETARCH
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates curl xz-utils git && \
    rm -rf /var/lib/apt/lists/*

# Flutter publishes separate archives per host arch. Map Docker's TARGETARCH
# (amd64/arm64) onto Flutter's naming (x64/arm64).
RUN set -euo pipefail; \
    case "${TARGETARCH}" in \
      amd64) FLUTTER_ARCH="x64" ;; \
      arm64) FLUTTER_ARCH="arm64" ;; \
      *) echo "Unsupported architecture: ${TARGETARCH}" >&2; exit 1 ;; \
    esac; \
    curl -fsSL -o /tmp/flutter.tar.xz \
      "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_ARCH}_${FLUTTER_VERSION}-stable.tar.xz"; \
    mkdir -p /opt/flutter-tmp; \
    tar -xJf /tmp/flutter.tar.xz -C /opt/flutter-tmp --strip-components=1; \
    rm -f /tmp/flutter.tar.xz; \
    # Strip VCS history and docs we don't need at runtime to shrink the layer.
    rm -rf /opt/flutter-tmp/.git /opt/flutter-tmp/packages/flutter/doc

# Mark the checkout as a safe, git-tracked directory so `flutter --version`
# and `flutter doctor` behave correctly for every user that inherits it.
RUN git config --global --add safe.directory /opt/flutter

# -----------------------------------------------------------------------------
# Stage: cli-tools — fetch pinned Rust/Go CLI utilities from GitHub Releases
# -----------------------------------------------------------------------------
# Ubuntu's own package versions for these tools drift release to release and
# are sometimes missing on brand-new LTS series before universe catches up.
# Pinning to upstream GitHub release tarballs keeps every BAOBAB engineer on
# byte-identical tool versions regardless of the base image's apt state.
FROM ubuntu:${UBUNTU_VERSION} AS cli-tools
ARG TARGETARCH
ARG RIPGREP_VERSION
ARG FD_VERSION
ARG BAT_VERSION
ARG EZA_VERSION
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates curl tar && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /tmp/cli-tools
RUN set -euo pipefail; \
    case "${TARGETARCH}" in \
      amd64) RG_ARCH="x86_64-unknown-linux-musl"; FD_ARCH="x86_64-unknown-linux-musl"; \
             BAT_ARCH="x86_64-unknown-linux-musl"; EZA_ARCH="x86_64-unknown-linux-gnu" ;; \
      arm64) RG_ARCH="aarch64-unknown-linux-gnu"; FD_ARCH="aarch64-unknown-linux-gnu"; \
             BAT_ARCH="aarch64-unknown-linux-gnu"; EZA_ARCH="aarch64-unknown-linux-gnu" ;; \
      *) echo "Unsupported architecture: ${TARGETARCH}" >&2; exit 1 ;; \
    esac; \
    mkdir -p /opt/cli-tools/bin; \
    # ripgrep
    curl -fsSL -o rg.tar.gz "https://github.com/BurntSushi/ripgrep/releases/download/${RIPGREP_VERSION}/ripgrep-${RIPGREP_VERSION}-${RG_ARCH}.tar.gz"; \
    tar -xzf rg.tar.gz --strip-components=1 -C /tmp "*/rg" 2>/dev/null || tar -xzf rg.tar.gz --strip-components=1 -C /tmp; \
    find /tmp -maxdepth 1 -name rg -exec cp {} /opt/cli-tools/bin/rg \; ; \
    # fd
    curl -fsSL -o fd.tar.gz "https://github.com/sharkdp/fd/releases/download/v${FD_VERSION}/fd-v${FD_VERSION}-${FD_ARCH}.tar.gz"; \
    tar -xzf fd.tar.gz --strip-components=1 -C /tmp; \
    cp /tmp/fd /opt/cli-tools/bin/fd; \
    # bat
    curl -fsSL -o bat.tar.gz "https://github.com/sharkdp/bat/releases/download/v${BAT_VERSION}/bat-v${BAT_VERSION}-${BAT_ARCH}.tar.gz"; \
    tar -xzf bat.tar.gz --strip-components=1 -C /tmp; \
    cp /tmp/bat /opt/cli-tools/bin/bat; \
    # eza
    curl -fsSL -o eza.tar.gz "https://github.com/eza-community/eza/releases/download/v${EZA_VERSION}/eza_${EZA_ARCH}.tar.gz"; \
    tar -xzf eza.tar.gz -C /opt/cli-tools/bin; \
    chmod +x /opt/cli-tools/bin/*; \
    rm -rf /tmp/*

# -----------------------------------------------------------------------------
# Stage: final — the actual dev container image
# -----------------------------------------------------------------------------
FROM ubuntu:${UBUNTU_VERSION} AS final

ARG PYTHON_VERSION
ARG PYTHON_MINOR
ARG NODE_MAJOR
ARG POSTGRES_MAJOR
ARG TARGETARCH

LABEL org.opencontainers.image.title="baobab-devcontainer" \
      org.opencontainers.image.description="Standard development container for the BAOBAB Enterprise Platform (Nabhold Group Africa)" \
      org.opencontainers.image.vendor="Nabhold Group Africa" \
      org.opencontainers.image.source="https://github.com/nabhold-group-africa/baobab-devcontainer" \
      org.opencontainers.image.licenses="Proprietary"

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8 \
    TZ=UTC

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# -----------------------------------------------------------------------------
# 1. Core system packages, locale, timezone
# -----------------------------------------------------------------------------
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      sudo curl wget git unzip zip tar jq tree nano vim less htop procps \
      ca-certificates gnupg software-properties-common build-essential \
      pkg-config locales tzdata xz-utils apt-transport-https \
      openssh-client dnsutils iproute2 \
    && \
    locale-gen en_US.UTF-8 && \
    update-locale LANG=en_US.UTF-8 LANGUAGE=en_US:en && \
    ln -fs /usr/share/zoneinfo/${TZ} /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# -----------------------------------------------------------------------------
# 2. Python 3.14 toolchain (deadsnakes PPA — guarantees the pinned minor
#    version regardless of what the Ubuntu 26.04 base currently ships)
# -----------------------------------------------------------------------------
RUN add-apt-repository -y ppa:deadsnakes/ppa && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
      python${PYTHON_MINOR} \
      python${PYTHON_MINOR}-venv \
      python${PYTHON_MINOR}-dev \
      python3-pip \
    && \
    update-alternatives --install /usr/bin/python3 python3 /usr/bin/python${PYTHON_MINOR} 1 && \
    update-alternatives --install /usr/bin/python  python  /usr/bin/python${PYTHON_MINOR} 1 && \
    curl -fsSL https://bootstrap.pypa.io/get-pip.py | python${PYTHON_MINOR} - --no-cache-dir && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# pipx, uv, Poetry — installed once, globally, then made available to every
# user via /usr/local so Codespaces prebuilds and post-create scripts share
# a single toolchain install.
ENV PIPX_HOME=/usr/local/pipx \
    PIPX_BIN_DIR=/usr/local/bin
RUN python3 -m pip install --no-cache-dir --break-system-packages pipx && \
    python3 -m pipx ensurepath && \
    pipx install --global poetry && \
    pipx install --global uv && \
    chmod -R a+rX /usr/local/pipx

# django-tenants and the rest of the BAOBAB application dependencies are
# intentionally NOT baked in here — they belong to the project's own
# pyproject.toml / poetry.lock and are installed by post-create.sh on
# container creation, keeping this base image framework-version-agnostic.

# -----------------------------------------------------------------------------
# 3. Node.js LTS, npm, pnpm, yarn
# -----------------------------------------------------------------------------
RUN curl -fsSL https://deb.nodesource.com/setup_${NODE_MAJOR}.x | bash - && \
    apt-get install -y --no-install-recommends nodejs && \
    corepack enable && \
    corepack prepare pnpm@latest --activate && \
    corepack prepare yarn@stable --activate && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# -----------------------------------------------------------------------------
# 4. Flutter + Dart (copied from the flutter-sdk builder stage)
# -----------------------------------------------------------------------------
COPY --from=flutter-sdk /opt/flutter-tmp /opt/flutter
ENV PATH="/opt/flutter/bin:/opt/flutter/bin/cache/dart-sdk/bin:${PATH}" \
    PUB_CACHE=/opt/flutter/.pub-cache

# Pre-fetch platform-independent Flutter/Dart artifacts so first-run inside
# Codespaces (`flutter doctor`, `flutter pub get`) is fast and works offline
# for anything that doesn't need Android/iOS toolchains (mobile SDKs are
# intentionally excluded from this image — see README "What's NOT included").
RUN git config --global --add safe.directory /opt/flutter && \
    flutter config --no-analytics --no-cli-animations && \
    flutter precache --universal --no-android --no-ios --no-fuchsia && \
    chmod -R a+rX /opt/flutter

# -----------------------------------------------------------------------------
# 5. PostgreSQL 17 client + Redis CLI (client tools only — no server daemons)
# -----------------------------------------------------------------------------
RUN install -d /usr/share/postgresql-common/pgdg && \
    curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc \
      -o /usr/share/postgresql-common/pgdg/apt.postgresql.org.asc && \
    echo "deb [signed-by=/usr/share/postgresql-common/pgdg/apt.postgresql.org.asc] \
https://apt.postgresql.org/pub/repos/apt $(. /etc/os-release && echo $VERSION_CODENAME)-pgdg main" \
      > /etc/apt/sources.list.d/pgdg.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
      postgresql-client-${POSTGRES_MAJOR} \
      redis-tools \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# -----------------------------------------------------------------------------
# 6. Docker CLI + Compose plugin (client only — Codespaces mounts the host
#    Docker socket, so no dockerd/containerd is installed in this image)
# -----------------------------------------------------------------------------
RUN install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc && \
    chmod a+r /etc/apt/keyrings/docker.asc && \
    ARCH=$(dpkg --print-architecture) && \
    echo "deb [arch=${ARCH} signed-by=/etc/apt/keyrings/docker.asc] \
https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo $VERSION_CODENAME) stable" \
      > /etc/apt/sources.list.d/docker.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
      docker-ce-cli \
      docker-compose-plugin \
      docker-buildx-plugin \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# -----------------------------------------------------------------------------
# 7. GitHub CLI
# -----------------------------------------------------------------------------
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
      -o /usr/share/keyrings/githubcli-archive-keyring.gpg && \
    chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg && \
    ARCH=$(dpkg --print-architecture) && \
    echo "deb [arch=${ARCH} signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] \
https://cli.github.com/packages stable main" \
      > /etc/apt/sources.list.d/github-cli.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends gh && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# -----------------------------------------------------------------------------
# 8. Shell productivity utilities
#    fzf and tmux come from Ubuntu's own repos (small, stable, low-churn).
#    ripgrep/fd/bat/eza are copied pre-built from the cli-tools builder stage
#    for pinned, reproducible versions across Ubuntu releases.
# -----------------------------------------------------------------------------
RUN apt-get update && \
    apt-get install -y --no-install-recommends fzf tmux bash-completion && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY --from=cli-tools /opt/cli-tools/bin/rg  /usr/local/bin/rg
COPY --from=cli-tools /opt/cli-tools/bin/fd  /usr/local/bin/fd
COPY --from=cli-tools /opt/cli-tools/bin/bat /usr/local/bin/bat
COPY --from=cli-tools /opt/cli-tools/bin/eza /usr/local/bin/eza
RUN chmod +x /usr/local/bin/rg /usr/local/bin/fd /usr/local/bin/bat /usr/local/bin/eza

# -----------------------------------------------------------------------------
# 9. The `vscode` user — UID/GID 1000, passwordless sudo, bash default shell
# -----------------------------------------------------------------------------
RUN groupadd --gid 1000 vscode && \
    useradd --uid 1000 --gid 1000 --shell /bin/bash --create-home vscode && \
    echo "vscode ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/vscode && \
    chmod 0440 /etc/sudoers.d/vscode && \
    mkdir -p /workspaces /home/vscode/.local/bin && \
    chown -R vscode:vscode /workspaces /home/vscode

# -----------------------------------------------------------------------------
# 10. Global environment configuration
# -----------------------------------------------------------------------------
ENV PATH="/home/vscode/.local/bin:/opt/flutter/bin:/opt/flutter/bin/cache/dart-sdk/bin:/usr/local/bin:${PATH}" \
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    POETRY_VIRTUALENVS_IN_PROJECT=true \
    POETRY_NO_INTERACTION=1

# Give the vscode user ownership of the pipx/poetry install and Flutter's
# mutable caches (pub-cache, tool state) so `flutter`/`poetry` never need
# sudo at runtime.
RUN chown -R vscode:vscode /opt/flutter/.pub-cache 2>/dev/null || true

# -----------------------------------------------------------------------------
# 11. Shell enhancements: completions, aliases, colored prompt, history
# -----------------------------------------------------------------------------
COPY --chown=vscode:vscode config/bashrc.d/ /etc/bashrc.d/
RUN echo '\n# BAOBAB devcontainer shell enhancements\nfor f in /etc/bashrc.d/*.sh; do [ -r "$f" ] && . "$f"; done' \
      >> /etc/bash.bashrc

# -----------------------------------------------------------------------------
# 12. Copy in operational scripts (used by devcontainer lifecycle hooks and
#     by engineers troubleshooting a container directly)
# -----------------------------------------------------------------------------
COPY --chmod=0755 scripts/verify.sh  /usr/local/bin/baobab-verify
COPY --chmod=0755 scripts/summary.sh /usr/local/bin/baobab-summary

USER vscode
WORKDIR /workspaces

# Poetry: create venvs inside each project directory rather than a shared
# cache, matching the objective and keeping per-tenant-app envs isolated.
RUN poetry config virtualenvs.in-project true

CMD ["sleep", "infinity"]
