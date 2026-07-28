# BAOBAB Development Container

The **BAOBAB Development Container** is the official, reproducible development environment for the **BAOBAB Enterprise Platform**, maintained by **Nabhold Group Africa – Platform Engineering**.

It provides a standardized toolchain for local development, GitHub Codespaces, Visual Studio Code Dev Containers, JetBrains Gateway, and compatible CI workflows. Every engineer works from the same curated environment, eliminating differences caused by operating systems, package managers, or manually installed tools.

The container is designed around a simple principle:

> **The development environment should be predictable, reproducible, and version controlled.**

Rather than relying on ad hoc installation guides or host-specific setup, the entire development environment is defined as infrastructure. Every build is produced from a deterministic configuration, ensuring that the same inputs always generate the same container image.

The image includes a carefully selected collection of development tools and runtimes for modern full-stack application development, including Python, Node.js, Flutter, Docker, PostgreSQL client utilities, Redis CLI, GitHub CLI, and numerous command-line productivity tools. These components are installed using pinned versions defined outside the Dockerfile, ensuring consistency across every build.

## Project Objectives

The BAOBAB Development Container is designed to:

* Provide a consistent development environment for every engineer.
* Eliminate "works on my machine" configuration issues.
* Produce deterministic and reproducible container images.
* Support both local development and cloud-hosted development environments.
* Minimize onboarding time for new contributors.
* Separate version management from infrastructure implementation.
* Serve as the single source of truth for the BAOBAB development toolchain.

## Intended Usage

The container is suitable for:

* Local development using Docker and Dev Containers.
* GitHub Codespaces.
* Visual Studio Code Dev Containers.
* JetBrains Gateway.
* Continuous Integration workflows requiring the same toolchain used by developers.
* Platform engineering and infrastructure automation.

By standardizing the development environment across all supported platforms, the BAOBAB Development Container enables teams to focus on building software rather than configuring development machines.
