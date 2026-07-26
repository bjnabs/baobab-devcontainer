# VS Code Dev Containers

The BAOBAB Development Container is designed to work seamlessly with Visual Studio Code through the Dev Containers extension. This integration provides a fully configured, containerized development environment directly within the editor, allowing developers to work inside the same standardized environment used by GitHub Codespaces and continuous integration pipelines.

By combining Visual Studio Code with the BAOBAB Development Container, developers gain the convenience of a local development experience without sacrificing reproducibility or consistency.

## Why Dev Containers?

Traditional development environments often require developers to install and maintain language runtimes, package managers, SDKs, and supporting tools on their local machines.

Dev Containers eliminate this requirement by moving the development environment into a Docker container.

This approach provides several advantages:

* Consistent development environments across the team.
* Simplified onboarding.
* Isolation from the host operating system.
* Reproducible tooling and configuration.
* Easy environment recreation.

The only host dependency is Docker and Visual Studio Code.

---

## Prerequisites

To use the BAOBAB Development Container with Visual Studio Code, install:

* Docker Engine or Docker Desktop
* Visual Studio Code
* The **Dev Containers** extension

BuildKit should be enabled to take advantage of the Dockerfile's optimized build process.

---

## Development Workflow

The recommended workflow is straightforward.

```text
Developer
     │
     ▼
Clone Repository
     │
     ▼
Open Folder in VS Code
     │
     ▼
Reopen in Dev Container
     │
     ▼
Build Development Container
     │
     ▼
Run Post-Creation Tasks
     │
     ▼
Ready for Development
```

Visual Studio Code automatically detects the repository's `.devcontainer` configuration and provisions the development environment.

---

## Dev Container Configuration

The `.devcontainer` directory defines how Visual Studio Code should create and configure the development environment.

Typical responsibilities include:

* Selecting the Dockerfile or container image.
* Configuring the workspace.
* Forwarding development ports.
* Setting environment variables.
* Running post-creation commands.
* Installing recommended extensions.
* Applying editor customizations.

The BAOBAB Development Container supplies the underlying operating system and toolchain, while the Dev Container configuration customizes the development experience for the repository.

---

## Workspace Initialization

When the container is created for the first time, Visual Studio Code performs a series of initialization tasks.

These typically include:

* Building the development container.
* Creating the `vscode` user environment.
* Executing BAOBAB post-creation scripts.
* Configuring the workspace.
* Installing project-specific dependencies.
* Preparing the development environment for immediate use.

Developers should allow these tasks to complete before beginning work.

---

## Verification

After the container has finished initializing, verify the environment.

Run:

```bash
baobab-verify
```

To inspect the installed toolchain and runtime configuration:

```bash
baobab-summary
```

These commands confirm that the container has been provisioned correctly and is ready for development.

---

## Daily Development

Once the container has been created, normal development proceeds exactly as it would on a native workstation.

Typical activities include:

* Editing source code.
* Running application services.
* Executing tests.
* Debugging applications.
* Managing dependencies.
* Building project artifacts.
* Committing source code.

All development occurs within the standardized BAOBAB environment while source code remains stored on the host filesystem.

---

## Updating the Development Environment

When the development container changes, Visual Studio Code can rebuild the container using the updated Dockerfile and configuration.

Typical scenarios include:

* New language runtime versions.
* Updated development tools.
* Additional helper utilities.
* Configuration improvements.
* Security updates.

Rather than modifying an existing container manually, developers should rebuild the environment to ensure it matches the version-controlled infrastructure.

---

## Performance

The BAOBAB Development Container is optimized for efficient local development.

Performance optimizations include:

* Multi-stage Docker builds.
* BuildKit cache mounts.
* Layer reuse.
* Architecture-aware artifact selection.
* Preinstalled language runtimes.
* Preconfigured development tooling.

These optimizations reduce build times while ensuring deterministic outputs.

---

## Best Practices

For the best development experience with Visual Studio Code:

* Treat the container as disposable.
* Keep project source code outside the image.
* Avoid installing shared tooling manually.
* Manage software versions through the project's version management process.
* Rebuild the container after infrastructure changes.
* Execute `baobab-verify` after major updates.
* Use project-local dependency management rather than global package installation.

Following these practices keeps local development aligned with GitHub Codespaces and CI environments.

---

## Relationship to GitHub Codespaces

GitHub Codespaces and Visual Studio Code Dev Containers share the same underlying development model.

Both use:

* the same Dockerfile;
* the same development toolchain;
* the same helper utilities;
* the same runtime configuration;
* the same verification process.

The primary difference is where the environment runs:

| Environment                       | Execution Location                  |
| --------------------------------- | ----------------------------------- |
| Visual Studio Code Dev Containers | Local Docker host                   |
| GitHub Codespaces                 | GitHub-managed cloud infrastructure |

Because both environments consume the same infrastructure, developers can transition between local and cloud-hosted development with little or no workflow changes.

---

## Summary

Visual Studio Code Dev Containers provide a powerful local development experience built upon the same deterministic infrastructure that powers GitHub Codespaces and the BAOBAB continuous integration environment. By combining containerized development with version-controlled infrastructure, the BAOBAB Development Container delivers a consistent, reproducible, and maintainable workspace that enables developers to focus on building software rather than configuring their machines.
