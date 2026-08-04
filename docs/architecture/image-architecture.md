---
title: Image Architecture
description: Learn how the BAOBAB container image is structured and how the runtime layers support the toolchain.
---

# Image Architecture

The BAOBAB Development Container is built using a multi-stage Docker architecture that separates one-time build activities from the final runtime environment. This design minimizes image size, improves build performance, and maintains a clean separation between build artifacts and the finished development container.

Rather than performing every installation in a single stage, the Dockerfile isolates large downloads and specialized build operations into dedicated builder stages. Only the required artifacts are copied into the final image.

This approach produces a development container that is smaller, easier to maintain, and more efficient to rebuild.

## Architecture Overview

The image is composed of three distinct build stages:

```text
                     ┌────────────────────────────┐
                     │      flutter-sdk           │
                     │                            │
                     │ • Download Flutter SDK     │
                     │ • Handle architecture      │
                     │   specific installation    │
                     │ • Remove unnecessary files │
                     └─────────────┬──────────────┘
                                   │
                                   │
                     ┌─────────────▼──────────────┐
                     │       cli-tools            │
                     │                            │
                     │ • Download pinned CLI      │
                     │   utilities                │
                     │ • Extract binaries         │
                     │ • Prepare runtime tools    │
                     └─────────────┬──────────────┘
                                   │
                                   │
                     ┌─────────────▼──────────────┐
                     │          final             │
                     │                            │
                     │ • Install operating system │
                     │ • Install language         │
                     │   runtimes                │
                     │ • Configure environment    │
                     │ • Copy build artifacts     │
                     │ • Verify image             │
                     │ • Publish runtime image    │
                     └────────────────────────────┘
```

Each stage has a single, well-defined responsibility.

---

## Stage 1 – `flutter-sdk`

The first stage is responsible exclusively for acquiring and preparing the Flutter SDK.

Its responsibilities include:

* downloading the correct Flutter release;
* handling architecture-specific installation;
* removing unnecessary documentation;
* preparing the SDK for the final image.

The implementation differs slightly depending on the target architecture.

For **AMD64**, the official Flutter release archive is downloaded and extracted.

For **ARM64**, the Flutter repository is cloned at the required release tag because official precompiled archives are not distributed for Linux ARM64.

By isolating Flutter into its own builder stage:

* Flutter downloads do not affect unrelated build layers.
* Rebuilding other parts of the image does not require downloading Flutter again.
* Large temporary files never appear in the final image.

---

## Stage 2 – `cli-tools`

The second builder stage retrieves command-line utilities distributed through GitHub Releases.

Examples include:

* ripgrep
* fd
* bat
* eza

These utilities are downloaded as release artifacts, extracted, and prepared for installation into the final image.

Keeping these downloads separate provides several advantages:

* operating system package updates do not invalidate CLI download layers;
* tool upgrades remain isolated;
* temporary archives never become part of the runtime image.

This stage effectively acts as a packaging step for externally distributed binaries.

---

## Stage 3 – `final`

The final stage assembles the complete development environment.

It combines:

* the Ubuntu base image;
* operating system packages;
* language runtimes;
* development tooling;
* Flutter artifacts;
* command-line utilities;
* BAOBAB helper scripts;
* runtime configuration.

This is the only stage that becomes the published container image.

Everything copied into this stage represents the complete development environment presented to developers.

---

## Why Multi-Stage Builds?

Multi-stage builds provide several important benefits.

### Smaller Runtime Image

Temporary downloads, archives, extraction directories, and one-time build dependencies remain in builder stages rather than increasing the size of the published image.

### Improved Cache Efficiency

Builder stages are isolated.

For example:

* updating Flutter does not invalidate CLI tool downloads;
* changing CLI versions does not trigger a Flutter rebuild;
* modifying operating system packages leaves builder stages untouched.

This improves incremental build performance.

### Cleaner Layer History

The final image contains only the software required at runtime.

Intermediate build artifacts remain confined to the stages where they are needed.

This results in a cleaner and easier-to-understand image history.

### Better Separation of Responsibilities

Each stage has a focused purpose.

This modular organization makes the Dockerfile easier to review, troubleshoot, and extend.

---

## Build Flow

The high-level build process can be summarized as follows:

```text
Configuration
      │
      ▼
versions.lock
      │
      ▼
───────────────────────────────────────────────
Stage 1: flutter-sdk
      │
      ├── Download Flutter
      └── Prepare SDK
───────────────────────────────────────────────
Stage 2: cli-tools
      │
      ├── Download CLI tools
      └── Extract binaries
───────────────────────────────────────────────
Stage 3: final
      │
      ├── Install operating system packages
      ├── Install language runtimes
      ├── Configure environment
      ├── Copy Flutter SDK
      ├── Copy CLI tools
      ├── Install helper scripts
      ├── Verify image
      └── Publish image
───────────────────────────────────────────────
      │
      ▼
BAOBAB Development Container
```

---

## Multi-Architecture Support

All build stages are designed to support both supported Linux architectures.

Docker Buildx supplies architecture information during the build process, allowing the Dockerfile to select architecture-specific artifacts when necessary without requiring separate Dockerfiles.

This provides a single, maintainable build definition for:

* Linux AMD64
* Linux ARM64

---

## Build Verification

Image verification occurs near the end of the final stage.

Before the build succeeds, the verification process confirms that:

* required tools are installed;
* expected software versions are available;
* user configuration is correct;
* the runtime environment matches project expectations.

By validating the image during construction, configuration issues are detected before publication rather than during development.

---

## Design Philosophy

The image architecture follows a simple guiding principle:

> **Build complex environments in isolated stages. Publish only what developers actually need.**

By separating acquisition, preparation, assembly, and verification into dedicated stages, the BAOBAB Development Container achieves a balance between performance, maintainability, reproducibility, and clarity. The result is an image architecture that is efficient to build, straightforward to understand, and resilient as the platform evolves.
