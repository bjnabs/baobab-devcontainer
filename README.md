# BAOBAB Development Container

> **Enterprise-grade, reproducible development environment for the BAOBAB Enterprise Platform.**

<!-- Badges -->

[![License: Apache-2.0](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](LICENSE)
[![Ubuntu](https://img.shields.io/badge/Ubuntu-26.04%20LTS-E95420?logo=ubuntu\&logoColor=white)](https://ubuntu.com/)
[![Docker](https://img.shields.io/badge/Docker-Enabled-2496ED?logo=docker\&logoColor=white)](https://www.docker.com/)
[![Dev Containers](https://img.shields.io/badge/Dev%20Containers-Supported-0A84FF?logo=visualstudiocode\&logoColor=white)](https://containers.dev/)
[![GitHub Codespaces](https://img.shields.io/badge/GitHub-Codespaces-181717?logo=github\&logoColor=white)](https://github.com/features/codespaces)
[![Build Status](https://img.shields.io/github/actions/workflow/status/<OWNER>/<REPOSITORY>/build.yml?branch=main\&label=Build)](https://github.com/<OWNER>/<REPOSITORY>/actions)
[![Latest Release](https://img.shields.io/github/v/release/<OWNER>/<REPOSITORY>?label=Release)](https://github.com/<OWNER>/<REPOSITORY>/releases)
[![OCI Image](https://img.shields.io/badge/OCI-Container%20Image-5A29E4)](https://github.com/<OWNER>/<REPOSITORY>/pkgs/container)
[![Platform](https://img.shields.io/badge/platform-linux%2Famd64%20%7C%20linux%2Farm64-success)](#supported-platforms)

The **BAOBAB Development Container** provides a deterministic, version-controlled, and enterprise-ready development environment for the **BAOBAB Enterprise Platform**. It enables developers to work from an identical software stack whether using local Docker, Visual Studio Code Dev Containers, GitHub Codespaces, or Continuous Integration (CI) pipelines.

Designed around **Infrastructure as Code (IaC)** principles, the project eliminates configuration drift by defining the complete development environment in source control. Every image is built from a centrally managed version manifest, validated through automated verification, and published as a reproducible OCI-compliant container image.

Unlike traditional development environments that require manual installation and ongoing maintenance, BAOBAB delivers a fully configured workspace that is consistent across machines, operating systems, and team members. This reduces onboarding time, improves collaboration, and ensures that development, testing, and automation all execute against the same trusted foundation.

## Why BAOBAB?

Modern software development often suffers from inconsistent tooling, undocumented workstation configuration, and environment-specific issues that are difficult to reproduce.

The BAOBAB Development Container addresses these challenges by providing:

* **Deterministic builds** through centralized version management.
* **Reproducible environments** across local development, Codespaces, and CI.
* **Enterprise-grade architecture** based on Infrastructure as Code principles.
* **Automated verification** to ensure every published image is complete and consistent.
* **A minimal, maintainable toolchain** focused on modern application development.
* **Clear separation of concerns** between infrastructure, configuration, and version management.

The result is a development platform that is predictable, maintainable, and scalable for both individual developers and engineering teams.

---

## Quick Start

Clone the repository:

```bash
git clone https://github.com/nabhold/baobab-devcontainer.git
cd baobab-devcontainer
```

Open the repository in your preferred development environment:

* **Visual Studio Code** — Reopen in **Dev Container** when prompted.
* **GitHub Codespaces** — Create a new Codespace directly from the repository.
* **Docker** — Build and run the development container locally.

Detailed setup instructions are available in the **Usage** section of this documentation.

---

## Documentation

The repository documentation is organised into two parts:

* **README.md** — A high-level overview and entry point for the project.
* **`docs/`** — Comprehensive technical documentation covering architecture, usage, reference material, and project governance.

When published through **GitHub Pages**, the `docs/` directory becomes the project's complete documentation site.

---

## Table of Contents

### Introduction

* [Overview](docs/overview.md)
* [Key Features](docs/key-features.md)
* [Design Principles](docs/design-principles.md)
* [Supported Platforms](docs/supported-platforms.md)
* [What's Included](docs/whats-included.md)
* [What's Not Included](docs/whats-not-included.md)

### Architecture

* [Repository Structure](docs/repository-structure.md)
* [Version Management](docs/version-management.md)
* [Image Architecture](docs/image-architecture.md)
* [Toolchain](docs/toolchain.md)
* [Build Process](docs/build-process.md)

### Usage

* [Running Locally](docs/running-locally.md)
* [GitHub Codespaces](docs/github-codespaces.md)
* [VS Code Dev Containers](docs/vscode-dev-containers.md)

### Reference

* [Build Arguments](docs/build-arguments.md)
* [Environment Variables](docs/environment-variables.md)
* [Helper Commands](docs/helper-commands.md)
* [Build Verification](docs/build-verification.md)
* [Health Checks](docs/health-checks.md)

### Project

* [Security](docs/security.md)
* [Contributing](docs/contributing.md)
* [Roadmap](docs/roadmap.md)
* [License](LICENSE)

### Appendix

* [FAQ](docs/appendix/faq.md)
* [Glossary](docs/appendix/glossary.md)
* [Common Commands](docs/appendix/common-commands.md)
* [External References](docs/appendix/external-references.md)
* [Support](docs/appendix/support.md)
* [Changelog](CHANGELOG.md)
* [Acknowledgements](docs/appendix/acknowledgements.md)

---

> **Note**
>
> Replace the placeholder values (`<OWNER>`, `<REPOSITORY>`, and the GitHub Actions workflow filename) with your actual GitHub repository details. Once those are updated, the badges will automatically display the current build status, latest release, and published OCI image information.

