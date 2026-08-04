---
title: What's Included
description: See the tools, runtimes, and utilities that are bundled into the BAOBAB development container.
---

# What's Included

The BAOBAB Development Container provides a carefully curated development environment containing the tools, runtimes, and utilities required to develop, test, and maintain applications on the BAOBAB Enterprise Platform.

Rather than attempting to include every available development tool, the image focuses on a cohesive, well-maintained toolchain that supports the platform's primary development workflows while remaining efficient and maintainable.

## Operating System

The image is built on a modern Ubuntu Long Term Support (LTS) release, providing a stable and widely supported Linux environment for development.

The operating system is configured with:

* UTF-8 locale support
* UTC as the default timezone
* Essential development libraries
* Modern package management utilities
* Standard Linux command-line tools

## Python Development

The container includes a complete Python development environment consisting of:

* A pinned Python interpreter
* `pip`
* `pipx`
* Poetry
* uv
* Virtual environment support
* Python development headers

Python is configured as the default interpreter, while Poetry is preconfigured to create project-local virtual environments for improved isolation and reproducibility.

## JavaScript and TypeScript Development

The image includes a modern Node.js development environment featuring:

* Node.js LTS
* npm
* Corepack
* pnpm
* Yarn

These tools support frontend development, build tooling, package management, and modern JavaScript workflows.

## Flutter and Dart Development

Flutter development is supported through a pre-installed Flutter SDK and the bundled Dart SDK.

The image includes:

* Flutter SDK
* Dart SDK
* Flutter pre-cache for supported platforms
* Flutter CLI configuration

Platform-independent artifacts are downloaded during the image build to reduce first-run setup time and improve the developer experience.

## Database Client Tools

To support local and remote database development, the image includes client utilities for commonly used data services.

Included tools:

* PostgreSQL Client
* Redis CLI

These clients allow developers to connect to external database services without requiring database server software inside the development container.

## Container Development

Container-based workflows are supported through the Docker client toolchain.

Included components:

* Docker CLI
* Docker Buildx
* Docker Compose Plugin

The image is designed to communicate with an external Docker daemon, such as the Docker socket provided by GitHub Codespaces or a local Docker installation, rather than running a Docker daemon inside the container.

## Source Control and Collaboration

The development environment includes tools that simplify source control and collaboration.

Included tools:

* Git
* GitHub CLI
* OpenSSH Client

These utilities support repository management, authentication, remote access, and GitHub workflows.

## Modern Command-Line Utilities

The container includes a collection of modern command-line tools that improve productivity while remaining lightweight and familiar.

Examples include:

* ripgrep
* fd
* bat
* eza
* fzf
* tmux
* jq
* tree
* curl
* wget
* unzip
* zip
* tar
* less
* nano
* vim
* htop

Together, these tools provide a productive command-line environment suitable for day-to-day software development.

## Development Utilities

A number of supporting packages are included to facilitate software compilation, debugging, networking, and general development tasks.

These include:

* Build tools
* Package configuration utilities
* DNS utilities
* Networking tools
* Certificate management
* Compression and archive utilities

These components form the foundation required by many language ecosystems and third-party development tools.

## BAOBAB Helper Commands

The image installs several BAOBAB-specific helper commands that simplify common development and lifecycle operations.

These include:

* `baobab-bootstrap`
* `baobab-post-create`
* `baobab-summary`
* `baobab-verify`

These utilities support environment initialization, post-creation tasks, verification, and environment inspection. They are documented in detail later in this guide.

## Shell Experience

The development environment includes several enhancements designed to improve the interactive shell experience.

These enhancements include:

* Bash completion
* Custom shell configuration
* Improved command history behavior
* Productivity aliases
* Enhanced command-line utilities

The objective is to provide a productive environment immediately after opening a terminal without requiring additional user configuration.

## Runtime Configuration

The image is preconfigured with sensible defaults, including:

* UTF-8 locale configuration
* Standard environment variables
* Poetry project settings
* Python runtime configuration
* Flutter environment configuration
* BAOBAB runtime metadata

These defaults reduce setup time while ensuring consistent behavior across all supported environments.

---

The BAOBAB Development Container intentionally includes only the tooling required to provide a complete, reliable, and reproducible development experience. By carefully curating the installed software and avoiding unnecessary packages, the project remains easier to maintain, faster to build, and more predictable to use.
