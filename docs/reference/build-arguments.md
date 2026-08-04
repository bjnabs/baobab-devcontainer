---
title: Build Arguments
description: Review the arguments used to configure and customize the BAOBAB container build.
---

# Build Arguments

The BAOBAB Development Container uses Docker build arguments to parameterize selected aspects of the image build while maintaining deterministic and reproducible outputs.

Unlike software versions, which are managed through the project's version management infrastructure, build arguments are limited to values that influence the build process itself or provide image metadata.

This deliberate separation reinforces one of the project's core design principles:

> **Configuration determines what is installed. Build arguments determine how the image is built or described.**

---

## Philosophy

Build arguments are intentionally used sparingly.

The Dockerfile does **not** use build arguments to determine runtime software versions. Instead, those versions are resolved before the build begins and consumed from `config/versions.lock`.

This approach prevents multiple sources of truth and ensures that version changes remain centralized and traceable.

---

## Supported Build Arguments

The Dockerfile currently supports the following build arguments.

| Build Argument   | Purpose                                   | Required |
| ---------------- | ----------------------------------------- | -------- |
| `UBUNTU_VERSION` | Selects the Ubuntu LTS base image         | Yes      |
| `VERSION`        | Records the image version as OCI metadata | No       |
| `BUILD_DATE`     | Records when the image was built          | No       |
| `REVISION`       | Records the source control revision       | No       |

These arguments either influence the base operating system or provide metadata describing the resulting image.

---

## `UBUNTU_VERSION`

`UBUNTU_VERSION` specifies the Ubuntu LTS release used as the base image.

Example:

```dockerfile
ARG UBUNTU_VERSION=26.04
```

This argument determines the operating system upon which the entire development environment is built.

Unlike language runtimes or development tools, the Ubuntu release represents a fundamental platform decision rather than an application dependency.

Because changing the operating system affects compatibility, package availability, and long-term support, it is managed independently of the project's version resolution workflow.

---

## `VERSION`

`VERSION` records the release version of the published development container.

Typical examples include:

```text
1.0.0
1.2.3
2026.07
```

This value is typically supplied by the release pipeline and embedded into the image as OCI-compliant metadata.

It does **not** influence which software is installed.

Instead, it provides traceability by identifying the published image.

---

## `BUILD_DATE`

`BUILD_DATE` records when the image was produced.

Typical values follow ISO 8601 format.

Example:

```text
2026-07-26T14:30:00Z
```

This information is stored as image metadata and assists with:

* release management;
* artifact traceability;
* operational diagnostics;
* auditing.

It has no effect on the installed software or runtime behavior.

---

## `REVISION`

`REVISION` records the source control revision from which the image was built.

This is typically the Git commit SHA produced by the CI pipeline.

Example:

```text
9c6c74f7b5d4...
```

Embedding the revision into the image enables developers and operators to identify the exact source code used to produce a particular container image.

This greatly simplifies debugging and release verification.

---

## OCI Image Metadata

The metadata-related build arguments are typically exposed through OCI image labels.

These labels provide information such as:

* image version;
* source revision;
* build date;
* project metadata.

OCI metadata allows container registries, automation tools, and deployment platforms to identify published images without inspecting their contents.

---

## Why Software Versions Are Not Build Arguments

One of the project's architectural decisions is to avoid using build arguments for managed software versions.

For example, the Dockerfile intentionally does **not** define arguments such as:

```dockerfile
ARG PYTHON_VERSION
ARG NODE_VERSION
ARG FLUTTER_VERSION
```

Instead, these values originate from the deterministic version management workflow:

```text
config/versions.yaml
        │
        ▼
config/resolve.sh
        │
        ▼
config/versions.lock
        │
        ▼
Dockerfile
```

This architecture provides:

* a single source of truth;
* deterministic builds;
* simplified upgrades;
* reduced duplication;
* improved maintainability.

---

## Passing Build Arguments

Build arguments may be supplied during image construction.

Example:

```bash
docker build \
  --build-arg UBUNTU_VERSION=26.04 \
  --build-arg VERSION=1.2.0 \
  --build-arg BUILD_DATE="$(date -u +%FT%TZ)" \
  --build-arg REVISION="$(git rev-parse HEAD)" \
  -t baobab-dev .
```

In practice, these values are commonly provided automatically by GitHub Actions or another CI/CD pipeline.

---

## Best Practices

When working with build arguments:

* Use them only for build-time configuration or metadata.
* Do not use them to manage software versions.
* Treat metadata as descriptive rather than functional.
* Keep the number of build arguments intentionally small.
* Prefer deterministic configuration files for runtime dependencies.

Following these practices keeps the Dockerfile focused, predictable, and easy to maintain.

---

## Summary

Build arguments play a limited but important role in the BAOBAB Development Container. They define the operating system foundation and capture metadata that improves traceability without influencing the installed development toolchain.

By reserving build arguments for infrastructure concerns and managing software versions through the project's dedicated version management process, the Dockerfile maintains a clear separation of responsibilities and reinforces the project's commitment to deterministic, reproducible builds.
