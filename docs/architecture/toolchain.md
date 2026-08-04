---
title: Toolchain
description: Inspect the languages, runtimes, and developer tooling that make up the BAOBAB environment.
---

# Toolchain

The BAOBAB Development Container includes a curated collection of language runtimes, development tools, command-line utilities, and supporting software that together provide a complete and consistent development environment.

Every component is intentionally selected to support the BAOBAB Enterprise Platform while adhering to the project's principles of determinism, reproducibility, and maintainability. Software versions are centrally managed through the version management infrastructure, ensuring that every published image contains a known and validated toolchain.

---

## Toolchain Philosophy

The BAOBAB toolchain is designed around three guiding principles:

* **Provide what every developer needs.**
* **Avoid unnecessary software and duplication.**
* **Manage every component deterministically.**

Rather than attempting to satisfy every possible development workflow, the image includes the common foundation required across BAOBAB projects. Project-specific tools and dependencies should be installed within the project itself rather than becoming part of the shared base image.

---

## Language Runtimes

The development container includes modern, production-ready language runtimes for the BAOBAB technology stack.

| Runtime     | Purpose                                                 |
| ----------- | ------------------------------------------------------- |
| Python      | Backend services, automation, scripting, tooling        |
| Node.js     | Frontend development, build tooling, package management |
| Dart        | Flutter development                                     |
| Flutter SDK | Cross-platform application development                  |

Each runtime is installed using a pinned version defined by the project's version management process.

---

## Python Toolchain

Python development is supported through a modern and reproducible ecosystem.

Included components include:

| Tool   | Purpose                                                 |
| ------ | ------------------------------------------------------- |
| Python | Primary programming language                            |
| pip    | Python package installer                                |
| pipx   | Isolated installation of Python applications            |
| Poetry | Dependency management and packaging                     |
| uv     | High-performance Python package and environment manager |
| venv   | Project-local virtual environments                      |

The container is configured to encourage isolated, project-specific environments rather than global package installation.

---

## JavaScript and TypeScript Toolchain

Modern JavaScript development is supported through the official Node.js ecosystem.

Included components include:

| Tool     | Purpose                       |
| -------- | ----------------------------- |
| Node.js  | JavaScript runtime            |
| npm      | Default package manager       |
| Corepack | Package manager orchestration |
| pnpm     | Efficient package manager     |
| Yarn     | Alternative package manager   |

These tools support frontend frameworks, build systems, and modern web development workflows.

---

## Flutter Development

Flutter support is included for cross-platform application development.

Installed components include:

| Component     | Purpose                           |
| ------------- | --------------------------------- |
| Flutter SDK   | Application framework             |
| Dart SDK      | Programming language runtime      |
| Flutter CLI   | Build and project management      |
| Flutter cache | Pre-downloaded platform artifacts |

The SDK is prepared during the image build to reduce initialization time for developers.

---

## Container Development

Container-based workflows are supported through the Docker client toolchain.

| Tool                  | Purpose                                 |
| --------------------- | --------------------------------------- |
| Docker CLI            | Container management                    |
| Docker Buildx         | Multi-platform image builds             |
| Docker Compose Plugin | Multi-container application development |

The development container communicates with an external Docker daemon and does not run Docker-in-Docker.

---

## Database Utilities

The image includes client tools for interacting with commonly used database systems.

| Tool              | Purpose                                   |
| ----------------- | ----------------------------------------- |
| PostgreSQL Client | PostgreSQL administration and development |
| Redis CLI         | Redis interaction and diagnostics         |

Database servers are intentionally excluded from the image.

---

## Source Control

Version control and repository management are supported through a modern Git workflow.

| Tool           | Purpose                      |
| -------------- | ---------------------------- |
| Git            | Distributed version control  |
| GitHub CLI     | GitHub repository management |
| OpenSSH Client | Secure remote connectivity   |

Together, these tools support authentication, collaboration, repository management, and secure access to remote infrastructure.

---

## Modern Command-Line Utilities

The development container replaces many traditional Unix utilities with modern alternatives that improve usability while remaining lightweight.

| Tool    | Purpose                                       |
| ------- | --------------------------------------------- |
| ripgrep | Fast recursive text searching                 |
| fd      | User-friendly file discovery                  |
| bat     | Enhanced file viewer with syntax highlighting |
| eza     | Modern replacement for `ls`                   |
| fzf     | Interactive fuzzy finder                      |
| jq      | JSON processing                               |
| tree    | Directory visualization                       |
| tmux    | Terminal multiplexing                         |
| htop    | Interactive process monitoring                |

These utilities significantly improve day-to-day productivity without changing established development workflows.

---

## System Utilities

The image includes a comprehensive collection of foundational Linux utilities used throughout software development.

Examples include:

* curl
* wget
* unzip
* zip
* tar
* less
* vim
* nano
* ca-certificates
* gnupg
* build-essential
* pkg-config

These packages provide the capabilities required by many language ecosystems and build systems.

---

## BAOBAB Helper Utilities

The development container includes several project-specific commands that simplify common operational tasks.

| Command              | Purpose                                               |
| -------------------- | ----------------------------------------------------- |
| `baobab-bootstrap`   | Initialize the development environment                |
| `baobab-post-create` | Execute post-creation setup tasks                     |
| `baobab-summary`     | Display environment and toolchain information         |
| `baobab-verify`      | Validate the integrity of the development environment |

These utilities provide a consistent operational interface while encapsulating project-specific implementation details.

---

## Runtime Configuration

The toolchain is complemented by a standardized runtime configuration that establishes consistent behavior across all supported environments.

Configuration includes:

* UTF-8 locale settings
* Environment variables
* Shell configuration
* Poetry defaults
* Python defaults
* Flutter configuration
* BAOBAB metadata

This ensures that every developer begins with the same baseline environment immediately after container creation.

---

## Version Management

Every managed component within the toolchain follows the project's deterministic version management process.

Software versions are:

* defined centrally;
* resolved before the build begins;
* recorded in the generated lock file;
* validated during image construction.

This process guarantees that every published image contains the exact toolchain expected by the project.

---

## A Curated Toolchain

The BAOBAB Development Container intentionally favors quality over quantity.

Every tool included in the image serves a specific purpose, supports a documented workflow, and contributes to a consistent developer experience. Components that are project-specific, platform-specific, or rarely required are deliberately excluded to keep the image focused, maintainable, and reproducible.

The result is a carefully curated toolchain that provides a solid foundation for application development while remaining efficient to build, straightforward to maintain, and predictable to use.
