---
title: Overview
description: Get a concise view of the BAOBAB development container and its primary goals.
---

# Overview

The BAOBAB Development Container provides a standardized, production-grade development environment for the BAOBAB Enterprise Platform. It encapsulates the complete development toolchain into a single Docker image, ensuring that every developer, regardless of operating system or workstation configuration, works within an identical environment.

Unlike traditional development environments that rely on manually installed software, package managers, and platform-specific configuration, the BAOBAB Development Container defines the entire development environment as code. Every runtime, command-line utility, and supporting tool is provisioned through a deterministic build process, producing an image that is reproducible across local machines, GitHub Codespaces, and continuous integration environments.

At the heart of this approach is a clear separation of responsibilities:

* **Version management** determines *what* versions of software should be installed.
* **The Dockerfile** defines *how* those versions are installed.
* **Development tools** consume the resulting environment without independently managing their own runtime versions.

This separation simplifies maintenance, reduces configuration drift, and allows tool versions to be updated through a controlled process without introducing unnecessary changes to the infrastructure.

The image is built using a multi-stage Docker architecture to minimize the final image size while keeping build steps isolated and cache-efficient. Large downloads, such as the Flutter SDK and selected command-line utilities, are retrieved in dedicated builder stages before only the required artifacts are copied into the final runtime image.

To ensure consistency across all supported platforms, the image supports both **Linux AMD64** and **Linux ARM64** architectures through Docker Buildx. The final container runs as a non-root user (`vscode`), mirroring the conventions used by GitHub Codespaces and Visual Studio Code Dev Containers while adhering to container security best practices.

The development container also incorporates build-time verification and runtime health checks. Before an image is published, an automated verification process validates that the installed toolchain, runtime configuration, user permissions, and expected software versions all match the project's requirements. This proactive validation helps detect configuration issues during image creation rather than after developers begin using the environment.

By treating the development environment as a version-controlled artifact, the BAOBAB Development Container delivers a consistent, maintainable, and reproducible foundation for application development, testing, and continuous integration.

## Intended Audience

This documentation is intended for:

* Platform engineers responsible for maintaining the development environment.
* Software engineers developing applications on the BAOBAB Enterprise Platform.
* Contributors who wish to understand or extend the development container.
* DevOps engineers integrating the image into CI/CD workflows.
* Organizations adopting standardized, container-based development environments.

Whether used locally or in the cloud, the BAOBAB Development Container provides a reliable foundation that enables teams to spend less time configuring development machines and more time delivering software.
