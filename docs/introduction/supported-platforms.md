---
title: Supported Platforms
description: Discover where BAOBAB can be used across local machines, cloud environments, and CI systems.
---

# Supported Platforms

The BAOBAB Development Container is designed to provide a consistent development experience across local workstations, cloud-hosted development environments, and continuous integration systems. Regardless of where the container runs, developers should work with the same toolchain, configuration, and runtime behavior.

By adhering to widely adopted container standards and modern Docker features, the image remains portable while taking advantage of platform-specific capabilities where appropriate.

## Operating Systems

The development container can be used from any operating system capable of running Docker or a compatible container runtime.

Supported host operating systems include:

* Linux
* macOS
* Windows (via Docker Desktop or Windows Subsystem for Linux 2)

Although the host operating system may differ, the development environment inside the container remains identical.

## Processor Architectures

The image supports multiple CPU architectures through Docker Buildx.

Supported architectures include:

* **Linux AMD64 (x86_64)**
* **Linux ARM64 (AArch64)**

Architecture-specific binaries are selected automatically during the build process where required, allowing the same Dockerfile to produce images for both platforms.

This enables native development on a wide range of hardware, including:

* Intel and AMD workstations
* Apple Silicon (M-series) Macs
* ARM64-based Linux servers
* ARM64 cloud development environments

## Development Environments

The BAOBAB Development Container is intended to integrate seamlessly with modern development workflows.

Supported environments include:

* Local Docker installations
* GitHub Codespaces
* Visual Studio Code Dev Containers
* JetBrains Gateway
* Other OCI-compatible container development environments

Each environment benefits from the same curated toolchain, ensuring a consistent developer experience regardless of where development takes place.

## Continuous Integration

The container can also be used as a standardized build environment for Continuous Integration (CI) systems.

Typical use cases include:

* application builds;
* automated testing;
* linting and static analysis;
* dependency management;
* documentation generation;
* release automation.

Using the same image in both development and CI reduces discrepancies between local builds and automated pipelines, improving reliability and simplifying troubleshooting.

## Container Runtime

The image is designed for OCI-compliant container runtimes that support modern Docker features.

Recommended runtimes include:

* Docker Engine
* Docker Desktop
* Docker Buildx
* GitHub Codespaces container infrastructure

BuildKit support is strongly recommended, as the Dockerfile is optimized to take advantage of advanced caching and multi-stage build capabilities.

## Development Editors

The container is editor-agnostic and can be used with any development environment that supports remote containers.

Officially supported workflows include:

* Visual Studio Code with the Dev Containers extension
* GitHub Codespaces
* JetBrains Gateway

Other editors capable of connecting to containerized development environments may also be used, provided they support the required Docker workflow.

## Platform Consistency

One of the primary goals of the BAOBAB Development Container is to eliminate differences between development environments.

Regardless of the host platform, every supported environment provides:

* the same operating system base;
* the same language runtimes;
* the same development tools;
* the same command-line utilities;
* the same environment configuration;
* the same verification process.

This consistency reduces onboarding time, minimizes environment-specific issues, and ensures that software behaves predictably throughout the development lifecycle.

---

By supporting multiple operating systems, processor architectures, development environments, and CI platforms, the BAOBAB Development Container provides a portable and reproducible foundation that enables developers to work confidently from virtually anywhere without sacrificing consistency or reliability.
