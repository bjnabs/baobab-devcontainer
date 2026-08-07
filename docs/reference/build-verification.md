---
title: Build Verification
description: Learn how to verify BAOBAB builds and validate the container artifacts before release.
---

# Build Verification

The BAOBAB Development Container includes an automated build verification process that validates the integrity of the development environment before an image is published or used by developers.

Verification is treated as an essential part of the build rather than an optional post-build activity. By validating the completed image during construction, configuration issues are detected immediately, reducing the likelihood of distributing incomplete or inconsistent development environments.

This approach reinforces the project's commitment to deterministic, reproducible, and reliable builds.

---

## Philosophy

The guiding principle is straightforward:

> **If the image cannot verify itself, it should not be published.**

Every published image should provide confidence that:

* the expected software is installed;
* the configured versions are available;
* the runtime environment is correctly configured;
* helper utilities function as intended.

Verification transforms the Docker build from a simple installation process into a quality assurance pipeline.

---

## Verification Workflow

Build verification occurs near the end of the Docker build process, after all software has been installed and the runtime environment has been configured.

The simplified workflow is:

```text
Resolve Versions
        │
        ▼
Install Software
        │
        ▼
Configure Environment
        │
        ▼
Run baobab-verify
        │
        ├── Pass ─────────► Publish Image
        │
        └── Fail ─────────► Build Fails
```

Only images that successfully complete verification are considered valid.

---

## Verification Scope

The verification process validates the overall health of the development environment rather than individual installation steps.

Typical verification checks include:

### Operating System

* Ubuntu version
* Locale configuration
* Timezone configuration
* Required system packages

---

### Language Runtimes

Verification confirms that required runtimes are installed and executable.

Examples include:

* Python
* Node.js
* Dart
* Flutter

Expected versions are compared against the deterministic configuration used during the build.

---

### Development Tools

The verification process confirms that key development utilities are available.

Examples include:

* Poetry
* uv
* npm
* pnpm
* Git
* GitHub CLI
* Docker CLI
* Docker Compose
* Docker Buildx

The goal is to ensure that the development toolchain is complete and operational.

---

### BAOBAB Helper Commands

All built-in helper commands are verified.

This includes:

* `baobab-bootstrap`
* `baobab-post-create`
* `baobab-summary`
* `baobab-verify`

Verifying these commands ensures that the operational interface exposed to developers is fully functional.

---

### Environment Configuration

Verification also checks runtime configuration.

Typical checks include:

* required environment variables;
* shell configuration;
* executable search path;
* runtime permissions;
* user configuration.

These checks ensure that the environment behaves consistently regardless of where the image is executed.

---

## Build-Time Verification

The Dockerfile executes the verification process before the build completes.

A typical verification step resembles:

```bash
baobab-verify
```

If the command exits successfully, the build continues.

If verification reports any failure, the Docker build terminates immediately.

This prevents incomplete or inconsistent images from being published.

---

## Runtime Verification

Verification is not limited to image construction.

Developers can execute the same validation after starting a container.

```bash
baobab-verify
```

This is particularly useful after:

* rebuilding the image;
* updating the development environment;
* creating a new Codespace;
* provisioning a Dev Container;
* troubleshooting unexpected behavior.

Using the same verification logic during both build time and runtime provides consistent validation across all supported environments.

---

## Failure Handling

If verification detects an issue, it should provide:

* a clear description of the failed check;
* the affected component;
* sufficient diagnostic information to identify the problem;
* a non-zero exit status.

Verification should avoid ambiguous error messages and instead help developers quickly identify the root cause of any failure.

---

## Continuous Integration

Because `baobab-verify` returns meaningful exit codes, it integrates naturally with automated pipelines.

Continuous Integration workflows can execute the same verification process used during image construction to confirm that published images remain valid.

This ensures that:

* local builds;
* GitHub Codespaces;
* Dev Containers;
* CI pipelines

all validate the development environment using the same criteria.

---

## Benefits

Automated build verification provides several important advantages:

* Early detection of configuration errors.
* Confidence in published images.
* Consistent validation across environments.
* Faster troubleshooting.
* Improved release quality.
* Reduced risk of distributing broken development environments.

Most importantly, verification ensures that successful builds are not merely complete—they are **correct**.

---

## Best Practices

To maximize the value of build verification:

* Run verification automatically during every image build.
* Execute `baobab-verify` after rebuilding or updating the environment.
* Treat verification failures as build failures.
* Extend verification whenever new shared tooling is added.
* Keep verification deterministic and independent of external services whenever possible.

Verification should remain fast, reliable, and focused on confirming the integrity of the development environment.

---

## Summary

Build verification is a cornerstone of the BAOBAB Development Container's quality assurance strategy. By validating the completed environment before publication and providing the same verification mechanism to developers and CI systems, the project ensures that every distributed image is complete, consistent, and ready for productive development. This commitment to automated validation strengthens the reproducibility, reliability, and maintainability of the entire platform.
