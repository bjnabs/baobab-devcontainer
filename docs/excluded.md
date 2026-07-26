# What's Not Included

The BAOBAB Development Container intentionally focuses on providing a standardized development environment rather than a complete application runtime. To keep the image maintainable, portable, and broadly applicable across projects, certain components are deliberately excluded.

These omissions are design decisions—not limitations.

## Application Source Code

The container does not include any BAOBAB application source code.

Application repositories are expected to be mounted into the container at runtime, allowing developers to work with the latest project code without rebuilding the image.

This separation ensures that the development environment can evolve independently of the applications it supports.

## Project Dependencies

The image provides the development toolchain but does **not** install project-specific dependencies.

Examples include:

* Python packages defined in `pyproject.toml`
* Poetry-managed project environments
* Node.js packages defined in `package.json`
* Flutter package dependencies

These dependencies are installed after the development container is created using the project's own dependency management workflow.

This approach ensures that:

* each project remains self-contained;
* dependencies remain version-controlled within the project;
* the base image stays framework-agnostic.

## Database Servers

The development container includes database **client** utilities only.

It does **not** include database server software such as:

* PostgreSQL Server
* Redis Server

Database services are expected to run externally, for example:

* Docker Compose services
* Dedicated development infrastructure
* Managed cloud services
* Shared development databases

This separation keeps the image lightweight while supporting a wide variety of deployment models.

## Docker Daemon

The image includes the Docker client, Docker Buildx, and the Docker Compose plugin, but it does **not** run its own Docker daemon.

Instead, it connects to an external Docker engine provided by:

* Docker Desktop
* A local Docker installation
* GitHub Codespaces
* Another compatible Docker host

Avoiding Docker-in-Docker simplifies the image, reduces resource usage, and follows established Dev Container and Codespaces practices.

## Mobile Platform SDKs

Although Flutter is included, platform-specific mobile SDKs are intentionally excluded.

This includes:

* Android SDK
* Android Emulator
* Android Studio
* Xcode
* iOS SDK

These components are significantly larger than the rest of the development environment and are often platform-specific.

Developers who require mobile application development can install the necessary SDKs on the host system or use specialized environments tailored to those workflows.

## Integrated Development Environments (IDEs)

The container does not include graphical development environments such as:

* Visual Studio Code
* JetBrains IDEs
* Android Studio

The image is designed to integrate with external editors through Dev Containers, remote development, or Codespaces.

This keeps the container independent of any particular editor while supporting multiple development workflows.

## Browser-Based Testing Tools

Web browsers and browser automation frameworks are not included by default.

Examples include:

* Google Chrome
* Chromium
* Firefox
* Playwright browsers
* Selenium browser binaries

Projects requiring browser-based testing should install these dependencies as part of their own testing environment rather than in the shared base image.

## Cloud Provider CLIs

Cloud-specific command-line tools are intentionally excluded.

Examples include:

* AWS CLI
* Azure CLI
* Google Cloud CLI

Not every project interacts with the same cloud platform, and including all provider-specific tooling would unnecessarily increase image size and maintenance overhead.

Projects that depend on a specific cloud provider should install the corresponding CLI as part of their own development workflow.

## Infrastructure Provisioning Tools

Infrastructure management tools are not bundled into the base image.

Examples include:

* Terraform
* OpenTofu
* Ansible
* Pulumi

These tools are highly project-dependent and evolve independently of the core development environment.

## Kubernetes Tooling

Container orchestration tools are not installed by default.

Examples include:

* kubectl
* Helm
* Kustomize
* Kind
* Minikube

Projects that require Kubernetes development can layer these tools on top of the base image or install them during project initialization.

## Language Runtimes Beyond the Core Stack

The image focuses on the primary technology stack used by the BAOBAB Enterprise Platform.

Additional language ecosystems such as:

* Java
* Go
* Rust
* .NET
* PHP
* Ruby

are intentionally omitted unless they become core platform requirements.

## Why These Components Are Excluded

Keeping the base image focused provides several benefits:

* Faster image builds.
* Smaller image size.
* Reduced maintenance effort.
* Lower security exposure.
* Fewer unnecessary updates.
* Clear separation between platform tooling and project-specific tooling.

Rather than attempting to satisfy every possible development workflow, the BAOBAB Development Container provides a stable foundation that projects can extend as needed.

---

The guiding principle is simple:

> **Include what every BAOBAB developer needs. Leave project-specific tools and dependencies to the projects that require them.**

This philosophy keeps the development environment lean, maintainable, and adaptable while ensuring that every engineer starts from the same reliable foundation.
