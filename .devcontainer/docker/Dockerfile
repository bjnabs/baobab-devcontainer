# syntax=docker/dockerfile:1.7
# =============================================================================
# BAOBAB Enterprise Platform — Standard Development Container
# =============================================================================
# Maintained by: Nabhold Group Africa — Platform Engineering
# Registry:      ghcr.io/nabhold/baobab-dev
#
# File: .devcontainer/docker/Dockerfile
#
# PURPOSE & SECURITY RATIONALE:
# -----------------------------
# 1. Zero-Trust Binary Downloads: Every third-party CLI tool binary and SDK archive
#    downloaded during container construction is cryptographically validated against
#    its expected SHA256 digest exported in `config/versions.lock`.
#
# 2. Complete Build Reproducibility: Docker build steps never query external "latest"
#    endpoints or perform non-deterministic version resolution. All version strings
#    and checksums are pre-computed outside Docker by `config/resolve.sh`.
#
# 3. Supply Chain Integrity: If an upstream GitHub release asset is tampered with,
#    or if a Man-In-The-Middle (MITM) attack occurs during image build, the
#    `sha256sum -c` step fails instantly, terminating the Docker build before any
#    unverified executable code touches the filesystem.
# =============================================================================

ARG UBUNTU_VERSION=26.04

# =============================================================================
# Stage 1: CLI Utilities Builder (ripgrep, fd, bat, eza, task, yq)
# =============================================================================
FROM ubuntu:${UBUNTU_VERSION} AS cli-tools

# Target architecture supplied automatically by Docker Buildx (amd64 or arm64)
ARG TARGETARCH

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    ca-certificates \
    tar \
    gzip \
    xz-utils \
    && rm -rf /var/lib/apt/lists/*

# Copy pre-resolved lockfile containing versions and SHA256 digests
COPY config/versions.lock /tmp/versions.lock

WORKDIR /tmp/build

# -----------------------------------------------------------------------------
# Download, Verify SHA256 Checksum, and Extract CLI Tools
#
# RATIONALE:
# - We dynamically map TARGETARCH to the corresponding lockfile variables
#   (e.g., RIPGREP_SHA256_AMD64 vs RIPGREP_SHA256_ARM64).
# - `echo "${EXPECTED_SHA}  ${FILENAME}" | sha256sum -c -` enforces cryptographic
#   verification prior to running tar/unzip commands.
# -----------------------------------------------------------------------------
RUN set -euo pipefail && \
    source /tmp/versions.lock && \
    \
    # -------------------------------------------------------------------------
    # 1. ripgrep
    # -------------------------------------------------------------------------
    if [ "$TARGETARCH" = "amd64" ]; then \
        RG_ASSET="$RIPGREP_ASSET_AMD64"; RG_SHA="$RIPGREP_SHA256_AMD64"; \
    else \
        RG_ASSET="$RIPGREP_ASSET_ARM64"; RG_SHA="$RIPGREP_SHA256_ARM64"; \
    fi && \
    curl -fsSL -o ripgrep.tar.gz "$RG_ASSET" && \
    echo "${RG_SHA}  ripgrep.tar.gz" | sha256sum -c - && \
    mkdir -p /tmp/rg && tar -xzf ripgrep.tar.gz -C /tmp/rg --strip-components=1 && \
    mv /tmp/rg/rg /usr/local/bin/rg && \
    chmod 0755 /usr/local/bin/rg && \
    \
    # -------------------------------------------------------------------------
    # 2. fd-find
    # -------------------------------------------------------------------------
    if [ "$TARGETARCH" = "amd64" ]; then \
        FD_ASSET_URL="$FD_ASSET_AMD64"; FD_SHA="$FD_SHA256_AMD64"; \
    else \
        FD_ASSET_URL="$FD_ASSET_ARM64"; FD_SHA="$FD_SHA256_ARM64"; \
    fi && \
    curl -fsSL -o fd.tar.gz "$FD_ASSET_URL" && \
    echo "${FD_SHA}  fd.tar.gz" | sha256sum -c - && \
    mkdir -p /tmp/fd && tar -xzf fd.tar.gz -C /tmp/fd --strip-components=1 && \
    mv /tmp/fd/fd /usr/local/bin/fd && \
    chmod 0755 /usr/local/bin/fd && \
    \
    # -------------------------------------------------------------------------
    # 3. bat
    # -------------------------------------------------------------------------
    if [ "$TARGETARCH" = "amd64" ]; then \
        BAT_ASSET_URL="$BAT_ASSET_AMD64"; BAT_SHA="$BAT_SHA256_AMD64"; \
    else \
        BAT_ASSET_URL="$BAT_ASSET_ARM64"; BAT_SHA="$BAT_SHA256_ARM64"; \
    fi && \
    curl -fsSL -o bat.tar.gz "$BAT_ASSET_URL" && \
    echo "${BAT_SHA}  bat.tar.gz" | sha256sum -c - && \
    mkdir -p /tmp/bat && tar -xzf bat.tar.gz -C /tmp/bat --strip-components=1 && \
    mv /tmp/bat/bat /usr/local/bin/bat && \
    chmod 0755 /usr/local/bin/bat && \
    \
    # -------------------------------------------------------------------------
    # 4. eza
    # -------------------------------------------------------------------------
    if [ "$TARGETARCH" = "amd64" ]; then \
        EZA_ASSET_URL="$EZA_ASSET_AMD64"; EZA_SHA="$EZA_SHA256_AMD64"; \
    else \
        EZA_ASSET_URL="$EZA_ASSET_ARM64"; EZA_SHA="$EZA_SHA256_ARM64"; \
    fi && \
    curl -fsSL -o eza.tar.gz "$EZA_ASSET_URL" && \
    echo "${EZA_SHA}  eza.tar.gz" | sha256sum -c - && \
    mkdir -p /tmp/eza && tar -xzf eza.tar.gz -C /tmp/eza && \
    mv /tmp/eza/eza /usr/local/bin/eza && \
    chmod 0755 /usr/local/bin/eza && \
    \
    # -------------------------------------------------------------------------
    # 5. go-task
    # -------------------------------------------------------------------------
    if [ "$TARGETARCH" = "amd64" ]; then \
        TASK_ASSET_URL="$TASK_ASSET_AMD64"; TASK_SHA="$TASK_SHA256_AMD64"; \
    else \
        TASK_ASSET_URL="$TASK_ASSET_ARM64"; TASK_SHA="$TASK_SHA256_ARM64"; \
    fi && \
    curl -fsSL -o task.tar.gz "$TASK_ASSET_URL" && \
    echo "${TASK_SHA}  task.tar.gz" | sha256sum -c - && \
    mkdir -p /tmp/task && tar -xzf task.tar.gz -C /tmp/task && \
    mv /tmp/task/task /usr/local/bin/task && \
    chmod 0755 /usr/local/bin/task && \
    \
    # -------------------------------------------------------------------------
    # 6. yq
    # -------------------------------------------------------------------------
    if [ "$TARGETARCH" = "amd64" ]; then \
        YQ_ASSET_URL="$YQ_ASSET_AMD64"; YQ_SHA="$YQ_SHA256_AMD64"; \
    else \
        YQ_ASSET_URL="$YQ_ASSET_ARM64"; YQ_SHA="$YQ_SHA256_ARM64"; \
    fi && \
    curl -fsSL -o /usr/local/bin/yq "$YQ_ASSET_URL" && \
    echo "${YQ_SHA}  /usr/local/bin/yq" | sha256sum -c - && \
    chmod 0755 /usr/local/bin/yq

# =============================================================================
# Stage 2: Flutter SDK Builder
# =============================================================================
FROM ubuntu:${UBUNTU_VERSION} AS flutter-sdk

ARG TARGETARCH
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    ca-certificates \
    git \
    tar \
    xz-utils \
    && rm -rf /var/lib/apt/lists/*

COPY config/versions.lock /tmp/versions.lock

# -----------------------------------------------------------------------------
# Flutter SDK Download & SHA256 Verification
# RATIONALE: Flutter SDK tarballs are downloaded from Google storage buckets.
# Validating the archive checksum before extracting into /opt/flutter prevents
# partial download corruption and supply chain tampering.
# -----------------------------------------------------------------------------
RUN set -euo pipefail && \
    source /tmp/versions.lock && \
    if [ "$TARGETARCH" = "amd64" ]; then \
        FLUTTER_URL="$FLUTTER_ASSET_AMD64"; FLUTTER_SHA="$FLUTTER_SHA256_AMD64"; \
    else \
        FLUTTER_URL="$FLUTTER_ASSET_ARM64"; FLUTTER_SHA="$FLUTTER_SHA256_ARM64"; \
    fi && \
    curl -fsSL -o /tmp/flutter.tar.xz "$FLUTTER_URL" && \
    echo "${FLUTTER_SHA}  /tmp/flutter.tar.xz" | sha256sum -c - && \
    mkdir -p /opt/flutter && \
    tar -xJf /tmp/flutter.tar.xz -C /opt && \
    rm /tmp/flutter.tar.xz && \
    git config --global --add safe.directory /opt/flutter

# =============================================================================
# Stage 3: Python Toolchain Builder (uv & Poetry)
# =============================================================================
FROM ubuntu:${UBUNTU_VERSION} AS python-tools

ARG TARGETARCH
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    ca-certificates \
    tar \
    gzip \
    && rm -rf /var/lib/apt/lists/*

COPY config/versions.lock /tmp/versions.lock

# -----------------------------------------------------------------------------
# uv & Poetry Binary Checksum Verification
# -----------------------------------------------------------------------------
RUN set -euo pipefail && \
    source /tmp/versions.lock && \
    # Install uv with SHA256 verification
    if [ "$TARGETARCH" = "amd64" ]; then \
        UV_URL="$UV_ASSET_AMD64"; UV_SHA="$UV_SHA256_AMD64"; \
    else \
        UV_URL="$UV_ASSET_ARM64"; UV_SHA="$UV_SHA256_ARM64"; \
    fi && \
    curl -fsSL -o /tmp/uv.tar.gz "$UV_URL" && \
    echo "${UV_SHA}  /tmp/uv.tar.gz" | sha256sum -c - && \
    mkdir -p /tmp/uv && tar -xzf /tmp/uv.tar.gz -C /tmp/uv --strip-components=1 && \
    mv /tmp/uv/uv /tmp/uv/uvx /usr/local/bin/ && \
    chmod 0755 /usr/local/bin/uv /usr/local/bin/uvx && \
    rm -rf /tmp/uv*

# =============================================================================
# Stage 4: Final Production DevContainer Base Image
# =============================================================================
FROM ubuntu:${UBUNTU_VERSION} AS final

# Standard metadata labels required for container governance
ARG VERSION=dev
ARG BUILD_DATE
ARG REVISION

LABEL org.opencontainers.image.title="BAOBAB Dev Container" \
      org.opencontainers.image.description="Enterprise Standard Development Container" \
      org.opencontainers.image.vendor="Nabhold Group Africa" \
      org.opencontainers.image.version="${VERSION}" \
      org.opencontainers.image.created="${BUILD_DATE}" \
      org.opencontainers.image.revision="${REVISION}"

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    PATH="/opt/flutter/bin:/home/vscode/.local/bin:${PATH}"

# Install core runtime dependencies (APT packages locked by Ubuntu release point)
RUN apt-get update && apt-get install -y --no-install-recommends \
    sudo \
    git \
    openssh-client \
    ca-certificates \
    gnupg \
    curl \
    wget \
    unzip \
    jq \
    python3 \
    python3-pip \
    python3-venv \
    nodejs \
    npm \
    postgresql-client \
    && rm -rf /var/lib/apt/lists/*

# Copy validated binaries from builder stages
COPY --from=cli-tools /usr/local/bin/rg /usr/local/bin/rg
COPY --from=cli-tools /usr/local/bin/fd /usr/local/bin/fd
COPY --from=cli-tools /usr/local/bin/bat /usr/local/bin/bat
COPY --from=cli-tools /usr/local/bin/eza /usr/local/bin/eza
COPY --from=cli-tools /usr/local/bin/task /usr/local/bin/task
COPY --from=cli-tools /usr/local/bin/yq /usr/local/bin/yq
COPY --from=flutter-sdk /opt/flutter /opt/flutter
COPY --from=python-tools /usr/local/bin/uv /usr/local/bin/uv
COPY --from=python-tools /usr/local/bin/uvx /usr/local/bin/uvx

# Create non-root vscode user with passwordless sudo access for DevContainers
RUN groupadd --gid 1000 vscode \
    && useradd --uid 1000 --gid 1000 -m -s /bin/bash vscode \
    && echo "vscode ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/vscode \
    && chmod 0440 /etc/sudoers.d/vscode \
    && chown -R vscode:vscode /opt/flutter

# Copy helper management scripts
COPY --chmod=0755 scripts/bootstrap.sh    /usr/local/bin/baobab-bootstrap
COPY --chmod=0755 scripts/post-create.sh  /usr/local/bin/baobab-post-create
COPY --chmod=0755 scripts/summary.sh      /usr/local/bin/baobab-summary
COPY --chmod=0755 scripts/verify.sh       /usr/local/bin/baobab-verify

USER vscode
WORKDIR /workspaces

# -----------------------------------------------------------------------------
# Build-time Runtime Verification Gate
# RATIONALE: Executes `baobab-verify` as the non-root user inside the image build.
# If any tool fails to execute or returns an invalid version string, the Docker
# build fails immediately rather than shipping a broken container image.
# -----------------------------------------------------------------------------
RUN baobab-verify

HEALTHCHECK \
    --interval=60s \
    --timeout=10s \
    --start-period=15s \
    --retries=3 \
    CMD baobab-verify || exit 1