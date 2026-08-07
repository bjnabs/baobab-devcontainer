---
title: Build Process
description: Understand how the BAOBAB development container is built, validated, and published from source.
---

# Build Process

The BAOBAB Development Container follows a deterministic build process that separates configuration, artifact preparation, image assembly, verification, and publication into distinct phases.

Rather than relying on implicit version resolution or ad hoc installation logic, every build is driven by explicit inputs and reproducible steps. This ensures that the same source code and configuration always produce the same development environment.

The build process is designed around the following principles:

* Resolve configuration before building.
* Build from deterministic inputs.
* Isolate independent build activities.
* Verify the completed environment before publication.
* Produce a reproducible development image.

---

## Build Workflow

The complete build workflow can be summarized as follows:

```text
                 Configuration
                       │
                       ▼
             config/versions.yaml
                       │
                       ▼
              config/resolve.sh
                       │
                       ▼
             config/versions.lock
                       │
                       ▼
                Docker BuildKit
                       │
      ┌────────────────┼────────────────┐
      ▼                ▼                ▼
flutter-sdk       cli-tools         final stage
      │                │                │
      └────────────────┼────────────────┘
                       ▼
           Build Verification
                       │
                       ▼
          BAOBAB Development Image
                       │
                       ▼
      Local Development / Codespaces / CI
```

Each phase has a clearly defined responsibility and produces an output consumed by the next phase.

---

## Phase 1 – Version Resolution

The build begins with configuration rather than Docker.

Software versions are defined in:

```text
config/versions.yaml
```

These human-maintained definitions are processed by the version resolution infrastructure to generate:

```text
config/versions.lock
```

The generated lock file becomes the authoritative build input.

By resolving versions before the Docker build starts, the project ensures that image construction is independent of external version discovery.

---

## Phase 2 – Build Initialization

Docker BuildKit initializes the build environment and evaluates the Dockerfile.

At this stage BuildKit:

* loads build arguments;
* determines the target architecture;
* prepares cache mounts;
* initializes build stages;
* establishes layer caching.

BuildKit support is recommended because the Dockerfile has been optimized to take advantage of modern caching capabilities that significantly improve incremental build performance.

---

## Phase 3 – Builder Stages

Independent builder stages prepare external artifacts before the final image is assembled.

### Flutter SDK

The Flutter builder stage:

* determines the target architecture;
* downloads the appropriate Flutter release;
* prepares the SDK;
* removes unnecessary files.

The prepared SDK is retained only long enough to be copied into the final image.

### Command-Line Utilities

A dedicated builder stage retrieves externally distributed command-line utilities.

These tools are downloaded using pinned versions, extracted, and prepared for installation into the runtime image.

Separating these downloads from the operating system installation improves cache efficiency and keeps the final image free from temporary artifacts.

---

## Phase 4 – Runtime Image Assembly

The final stage constructs the complete development environment.

This stage performs tasks such as:

* installing operating system packages;
* configuring package repositories;
* installing language runtimes;
* installing development tools;
* copying prepared artifacts from builder stages;
* installing BAOBAB helper utilities;
* configuring environment variables;
* creating the runtime user;
* applying development environment configuration.

Only the components required by developers are included in the published image.

---

## Phase 5 – Environment Configuration

After software installation, the development environment is configured.

Typical configuration includes:

* locale settings;
* timezone configuration;
* shell configuration;
* runtime environment variables;
* Poetry defaults;
* Flutter configuration;
* Git configuration;
* user permissions.

These settings establish a consistent runtime environment across all supported platforms.

---

## Phase 6 – Build Verification

Before the image is considered complete, the build executes an automated verification process.

The verification step confirms that:

* required software is installed;
* expected versions are present;
* helper commands are available;
* runtime configuration is correct;
* user permissions are properly configured;
* the development environment is internally consistent.

If verification fails, the image build fails.

This approach detects configuration problems before images are published or distributed to developers.

---

## Phase 7 – Image Publication

Once verification succeeds, the completed image becomes suitable for publication.

The image can then be:

* pushed to a container registry;
* referenced by GitHub Codespaces;
* consumed by Visual Studio Code Dev Containers;
* used within Continuous Integration pipelines;
* executed locally using Docker.

Because every published image originates from deterministic inputs, each release can be reproduced from source.

---

## Build Caching

The Dockerfile is designed to maximize Docker BuildKit caching without compromising reproducibility.

Key caching strategies include:

* isolated builder stages;
* cache-mounted package downloads;
* reusable image layers;
* architecture-aware artifact preparation;
* separation of frequently changing and infrequently changing components.

These optimizations reduce rebuild times while preserving deterministic outputs.

---

## Multi-Architecture Builds

The same Dockerfile supports both supported Linux architectures.

During the build, Docker Buildx provides architecture information that allows the Dockerfile to select the appropriate binaries and installation methods for:

* Linux AMD64
* Linux ARM64

No separate Dockerfiles are required.

This simplifies maintenance while ensuring native support across modern developer hardware.

---

## Build Reproducibility

The BAOBAB Development Container treats reproducibility as a core requirement rather than an optional feature.

A build is considered reproducible when:

* identical configuration produces identical software versions;
* infrastructure behaves consistently across environments;
* image contents are predictable;
* build verification produces the same outcome for the same inputs.

This philosophy reduces configuration drift, simplifies troubleshooting, and provides confidence that development, testing, and CI environments all share the same foundation.

---

## Build Lifecycle Summary

The complete lifecycle can be summarized as:

1. Define software versions.
2. Resolve deterministic build inputs.
3. Build isolated artifacts.
4. Assemble the runtime image.
5. Configure the development environment.
6. Verify the completed image.
7. Publish a reproducible development container.

---

The BAOBAB Development Container's build process emphasizes clarity, reproducibility, and maintainability. By separating configuration from infrastructure, isolating independent build activities, validating the final environment, and leveraging modern Docker capabilities, the project delivers a reliable development image that can be reproduced consistently across local workstations, cloud development environments, and continuous integration systems.
