---
title: Repository Structure
description: Explore the BAOBAB repository layout and the purpose of the key directories and scripts.
---

# Repository Structure

The BAOBAB Development Container repository is organized to separate infrastructure, configuration, automation, and documentation into clearly defined areas. This structure improves maintainability, simplifies navigation, and reinforces the project's philosophy of separation of concerns.

While the repository may evolve over time, its organization is designed to keep related functionality together and minimize coupling between components.

```text
baobab-dev/
├── .devcontainer/          # Dev Container configuration
├── .github/                # GitHub Actions and repository configuration
├── config/                 # Version management and shared configuration
├── docs/                   # Project documentation (GitHub Pages)
├── scripts/                # BAOBAB helper commands
├── Dockerfile              # Development container definition
├── README.md               # Project overview and quick start
└── LICENSE                 # Project license
```

> **Note:** The exact repository contents may expand over time, but the overall organization and separation of responsibilities should remain consistent.

## `.devcontainer/`

This directory contains the configuration required by Visual Studio Code Dev Containers and GitHub Codespaces.

Typical contents include:

* `devcontainer.json`
* Feature configuration
* Container customization
* Development lifecycle hooks

This directory defines how development environments consume the published container image.

---

## `.github/`

The `.github` directory contains repository automation and project configuration.

Typical contents include:

* GitHub Actions workflows
* Issue templates
* Pull request templates
* Dependabot configuration
* Repository metadata

Build, validation, testing, publishing, and release automation are managed here.

---

## `config/`

The `config` directory is the central location for version management and shared configuration.

Typical contents include:

```text
config/
├── versions.yaml
├── versions.lock
└── resolve.sh
```

Responsibilities include:

* Defining managed software versions.
* Resolving version constraints.
* Producing deterministic lock files.
* Providing configuration consumed during image builds.

This directory forms the foundation of the project's deterministic build process.

---

## `docs/`

The `docs` directory contains the project's long-form documentation.

It serves as the source for the GitHub Pages documentation site and complements the concise information provided in the repository's `README.md`.

Typical topics include:

* Getting Started
* Architecture
* Version Management
* Build Process
* Reference Documentation
* Contributor Guides
* Troubleshooting

Documentation is maintained alongside the source code to ensure it evolves with the project.

---

## `scripts/`

The `scripts` directory contains executable helper utilities used throughout the development lifecycle.

Examples include:

```text
scripts/
├── bootstrap.sh
├── post-create.sh
├── summary.sh
└── verify.sh
```

These scripts support tasks such as:

* Environment initialization.
* Post-creation configuration.
* Environment verification.
* Development environment inspection.

Within the container, these scripts are installed as the following commands:

* `baobab-bootstrap`
* `baobab-post-create`
* `baobab-summary`
* `baobab-verify`

This provides a stable command-line interface while allowing the implementation to evolve.

---

## `Dockerfile`

The Dockerfile defines the complete BAOBAB Development Container.

Its responsibilities include:

* Building the development environment.
* Installing runtimes and tooling.
* Configuring the operating system.
* Defining the container user.
* Setting runtime configuration.
* Performing build-time verification.
* Publishing image metadata.

The Dockerfile intentionally consumes configuration rather than defining software versions itself.

---

## `README.md`

The README provides a concise introduction to the project.

Its purpose is to help new users quickly understand:

* what the project is;
* what it provides;
* how to get started;
* where to find additional documentation.

For detailed technical guidance, readers are directed to the documentation in the `docs/` directory.

---

## Repository Organization Principles

The repository is organized according to several guiding principles.

### Separation of Responsibilities

Configuration, infrastructure, automation, documentation, and scripts each occupy their own dedicated location.

This makes the repository easier to navigate and reduces unintended coupling between components.

### Infrastructure as Code

Every aspect of the development environment—from version management to helper utilities—is maintained alongside the source code and reviewed through the same collaborative workflow.

### Documentation as Code

Documentation is treated as a first-class project artifact.

By keeping documentation within the repository:

* changes remain version-controlled;
* documentation evolves with the codebase;
* pull requests include both implementation and documentation updates.

### Predictability

Developers should be able to locate functionality without memorizing project-specific conventions.

The directory layout favors clarity and consistency over unnecessary complexity.

---

The repository structure reflects the same engineering philosophy that underpins the development container itself: clear separation of concerns, deterministic configuration, maintainable infrastructure, and comprehensive documentation. As the project grows, new components should integrate into this structure without compromising its simplicity or consistency.
