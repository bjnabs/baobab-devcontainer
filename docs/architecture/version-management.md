---
title: Version Management
description: See how BAOBAB pins and manages versions for the base image, runtimes, and supporting tools.
---

# Version Management

One of the defining characteristics of the BAOBAB Development Container is its deterministic approach to version management. Rather than allowing the Dockerfile to discover or resolve software versions during the build process, all version decisions are made beforehand through a dedicated configuration workflow.

This separation ensures that the Dockerfile remains focused solely on building the development environment, while version management is handled independently.

## Philosophy

The project follows a simple principle:

> **Resolve versions once. Consume them everywhere.**

By separating version resolution from infrastructure, the build process becomes predictable, reproducible, and easier to maintain.

This architecture provides several benefits:

* A single source of truth for managed software versions.
* Deterministic image builds.
* Simplified dependency upgrades.
* Reduced configuration drift.
* Clear separation between configuration and implementation.

## Version Management Workflow

The version management process consists of three primary components:

```text
versions.yaml
        │
        ▼
resolve.sh
        │
        ▼
versions.lock
        │
        ▼
Dockerfile
        │
        ▼
Container Image
```

Each component has a distinct responsibility.

---

## `versions.yaml`

The `config/versions.yaml` file is the authoritative configuration for managed software versions.

It defines the desired versions of the runtimes, tools, and supporting software included in the development container.

Rather than hard-coding version numbers throughout the repository, all managed versions are maintained centrally within this file.

Typical entries include:

* Python
* Node.js
* Flutter
* PostgreSQL Client
* ripgrep
* fd
* bat
* eza

The Dockerfile intentionally does **not** consume this file directly.

---

## `resolve.sh`

The `config/resolve.sh` script transforms the human-maintained configuration into a deterministic lock file suitable for automated builds.

Its responsibilities include:

* validating version configuration;
* resolving derived values;
* normalizing version data;
* generating a build-ready lock file.

Version resolution occurs **before** the Docker build begins.

The Dockerfile never executes this script during image construction.

This separation guarantees that version resolution is not influenced by the build environment.

---

## `versions.lock`

The generated `config/versions.lock` file is the only version source consumed by the Dockerfile.

Every runtime, command-line utility, and managed dependency installed during the build reads its version information from this lock file.

Because the lock file is generated before the build starts, every build using the same lock file produces the same software versions.

The lock file therefore serves as the build contract between configuration and infrastructure.

---

## Why the Dockerfile Uses a Lock File

Docker builds should be deterministic.

If the Dockerfile were responsible for resolving versions dynamically, identical builds performed at different times could produce different images.

Instead, the Dockerfile simply reads already-resolved version information and performs the installation.

This provides:

* reproducible builds;
* predictable updates;
* easier code reviews;
* improved debugging;
* consistent CI behavior.

The Dockerfile becomes a consumer of configuration rather than an author of configuration.

---

## Separation of Responsibilities

The version management architecture deliberately separates concerns.

| Component       | Responsibility                            |
| --------------- | ----------------------------------------- |
| `versions.yaml` | Defines desired software versions         |
| `resolve.sh`    | Resolves and validates configuration      |
| `versions.lock` | Provides deterministic build inputs       |
| Dockerfile      | Installs software using resolved versions |

This separation allows each component to evolve independently while maintaining a predictable build process.

---

## Updating Software Versions

Updating a managed tool typically follows a straightforward workflow:

1. Modify the appropriate version in `config/versions.yaml`.
2. Run `config/resolve.sh` to regenerate `config/versions.lock`.
3. Review the generated changes.
4. Rebuild the development container.
5. Verify the resulting image using the project's verification process.
6. Commit both configuration files together.

Treating the configuration and lock file as a single logical change ensures that the repository always contains the exact inputs required to reproduce a published image.

---

## Why Not Resolve Versions During the Build?

Resolving versions during `docker build` introduces unnecessary variability.

External package repositories, APIs, or scripts may change over time, resulting in builds that differ despite using the same Dockerfile.

By resolving versions beforehand, the build process becomes independent of those changes and can be reproduced long after the original image was created.

This philosophy aligns with established practices used by dependency lock files such as:

* `poetry.lock`
* `package-lock.json`
* `pnpm-lock.yaml`
* `Cargo.lock`
* `go.sum`

In the same way these files lock application dependencies, `versions.lock` locks the development environment itself.

---

## Future Evolution

The current version management architecture establishes a strong foundation for deterministic builds.

As the project evolves, the same workflow can be extended to include additional build metadata, such as:

* cryptographic checksums for downloaded artifacts;
* software provenance information;
* release metadata;
* architecture-specific validation.

These enhancements can be incorporated without changing the Dockerfile's fundamental role as a consumer of resolved configuration.

---

The version management system is a cornerstone of the BAOBAB Development Container. By resolving software versions before the build begins and treating the generated lock file as the authoritative build input, the project achieves a development environment that is reproducible, maintainable, and predictable across every supported platform and every stage of the software lifecycle.
