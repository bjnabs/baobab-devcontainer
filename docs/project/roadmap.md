---
title: Roadmap
description: See the planned direction and near-term priorities for BAOBAB.
---

# Roadmap

The BAOBAB Development Container is intended to serve as the long-term foundation for the BAOBAB Enterprise Platform's development environment. While the current implementation already provides a deterministic, reproducible, and maintainable toolchain, the project will continue to evolve alongside the platform and the broader container ecosystem.

This roadmap outlines the project's strategic direction rather than committing to specific release dates. Priorities may change as requirements evolve and new technologies emerge.

---

## Guiding Vision

The long-term objective is to provide:

> **A secure, deterministic, cross-platform development environment that requires minimal setup, remains straightforward to maintain, and scales with the BAOBAB Enterprise Platform.**

Every enhancement should reinforce the project's core principles rather than introduce unnecessary complexity.

---

# Near-Term Priorities

The following improvements represent the highest priorities for the next phase of the project.

## Complete Documentation

Continue expanding and refining the project's documentation to provide comprehensive guidance for:

* installation;
* architecture;
* troubleshooting;
* contributor onboarding;
* operational workflows;
* best practices.

The goal is for the documentation to become the definitive reference for both users and contributors.

---

## CI/CD Enhancements

Continue improving the GitHub Actions workflows by strengthening automation around:

* image builds;
* multi-architecture publishing;
* verification;
* release management;
* documentation deployment.

Future pipeline improvements should further reduce manual intervention while preserving deterministic builds.

---

## Automated Dependency Updates

Introduce automated tooling to assist with dependency maintenance.

Potential capabilities include:

* detecting new upstream releases;
* validating compatibility;
* proposing version updates;
* regenerating lock files;
* opening automated pull requests for review.

Automation should assist maintainers without bypassing the project's review process.

---

## Expanded Verification

Extend `baobab-verify` to perform more comprehensive validation.

Future checks may include:

* SDK integrity;
* runtime configuration consistency;
* helper command validation;
* architecture-specific verification;
* metadata validation.

Verification should continue to remain deterministic, fast, and suitable for both local development and CI pipelines.

---

# Medium-Term Goals

These initiatives build upon the current architecture and improve maintainability, observability, and developer productivity.

## Supply Chain Improvements

Enhance software provenance and artifact validation by introducing:

* checksum verification;
* cryptographic signature verification where available;
* Software Bill of Materials (SBOM) generation;
* image attestation;
* provenance metadata.

These capabilities improve transparency and strengthen confidence in published images.

---

## Security Scanning

Expand automated security validation within the CI pipeline.

Potential additions include:

* container vulnerability scanning;
* dependency auditing;
* license compliance checks;
* Dockerfile linting;
* shell script analysis.

These checks should complement—not replace—the existing build verification process.

---

## Performance Optimization

Continue refining image build performance through improvements such as:

* better layer organization;
* enhanced BuildKit cache utilization;
* optimized artifact downloads;
* reduced rebuild times;
* improved image size.

Performance improvements should never compromise reproducibility.

---

## Improved Diagnostics

Expand the BAOBAB helper utilities to simplify troubleshooting.

Potential enhancements include:

* richer diagnostic reports;
* environment comparison tools;
* detailed verification output;
* configuration inspection commands;
* automated issue collection.

The goal is to reduce the effort required to diagnose development environment issues.

---

# Long-Term Vision

The following initiatives represent strategic opportunities for the continued evolution of the project.

## Modular Toolchain

Investigate a modular image architecture that allows projects to extend the base development container with optional capabilities.

Examples include:

* cloud provider tooling;
* Kubernetes tooling;
* infrastructure automation tools;
* data engineering utilities;
* language-specific extensions.

The core image should remain intentionally minimal, while extensions provide specialized functionality when required.

---

## Enterprise Image Variants

Develop additional image variants tailored to different engineering disciplines.

Potential variants could include:

* Backend Development
* Frontend Development
* Mobile Development
* Data Engineering
* Platform Engineering
* Infrastructure Engineering

Each variant would inherit the same architectural principles while providing role-specific tooling.

---

## Automated Release Management

Further automate the image release lifecycle.

Future capabilities may include:

* semantic versioning;
* automated changelog generation;
* release notes;
* image signing;
* registry publication;
* release verification.

The objective is to create a predictable, auditable release process requiring minimal manual intervention.

---

## Expanded Platform Support

Continue evaluating additional platforms and container technologies as they mature.

Areas of interest include:

* emerging Linux distributions;
* new processor architectures;
* alternative OCI-compatible runtimes;
* future development environment integrations.

Support will be considered only where it aligns with the project's goals of maintainability and reproducibility.

---

# Ideas Under Evaluation

The following ideas are being explored but are not currently planned for implementation.

Potential future enhancements include:

* Development environment telemetry (opt-in only)
* Interactive setup assistants
* Additional helper commands
* Documentation generation automation
* Development environment benchmarking
* Enhanced shell customizations
* Project template integration

These ideas will be evaluated based on their long-term value, implementation complexity, and alignment with the project's guiding principles.

---

# Roadmap Principles

Future development will continue to be guided by the following priorities:

1. Maintain deterministic and reproducible builds.
2. Keep the Dockerfile simple and maintainable.
3. Preserve the separation between configuration and infrastructure.
4. Minimize unnecessary dependencies.
5. Automate repetitive tasks where appropriate.
6. Prioritize developer experience without sacrificing maintainability.
7. Document architectural decisions as the project evolves.

These principles provide a consistent framework for evaluating future enhancements.

---

# Summary

The BAOBAB Development Container has been designed with longevity in mind. Its architecture deliberately favors clear separation of concerns, deterministic builds, and maintainable infrastructure, providing a solid foundation for future growth.

The roadmap reflects an incremental approach to improvement: strengthen automation, expand verification, enhance security and observability, and introduce new capabilities only when they reinforce the project's architectural principles. By evolving thoughtfully rather than accumulating complexity, the BAOBAB Development Container will remain a dependable and scalable development platform for years to come.
