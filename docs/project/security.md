---
title: Security
description: Review BAOBAB security guidance, disclosure practices, and operational expectations.
---

# Security

Security is a fundamental design consideration of the BAOBAB Development Container. Although the image is intended for development rather than production workloads, it follows industry best practices to minimize unnecessary risk while maintaining a productive developer experience.

Rather than treating security as a single feature, the project incorporates security throughout the image lifecycle—from dependency management and image construction to runtime configuration and ongoing maintenance.

---

## Security Philosophy

The BAOBAB Development Container is built around several core security principles:

* **Least privilege** — perform operations with the minimum required permissions.
* **Deterministic builds** — build from known, version-controlled inputs.
* **Minimal attack surface** — include only necessary software.
* **Transparent infrastructure** — define and review all configuration as code.
* **Continuous validation** — verify the environment during build and runtime.

These principles guide every architectural decision within the project.

---

## Non-Root Runtime

The development environment is designed to run as a non-root user.

Administrative privileges are used only during image construction to install and configure software. Once the image has been built, development activities occur using an unprivileged user account.

Running as a non-root user provides several benefits:

* Reduces the impact of accidental system modifications.
* Limits the potential damage from compromised development tools.
* Aligns with container security best practices.
* Produces behavior that more closely resembles production environments.

Developers should avoid switching to the root user unless absolutely necessary.

---

## Deterministic Software Versions

All managed software versions are resolved before the Docker build begins.

The Dockerfile consumes only the generated `config/versions.lock` file, ensuring that every build uses the exact versions approved by the project.

This approach:

* prevents accidental upgrades;
* simplifies security reviews;
* improves vulnerability tracking;
* enables reproducible builds.

Because software versions are centrally managed, updating a dependency becomes a deliberate and reviewable change.

---

## Minimal Base Image

The BAOBAB Development Container includes only the tooling required for platform development.

Software that is not broadly required is intentionally excluded, including:

* database servers;
* cloud provider CLIs;
* Kubernetes tooling;
* graphical development environments;
* mobile platform SDKs.

Reducing unnecessary software decreases:

* image size;
* maintenance effort;
* dependency count;
* potential attack surface.

A smaller image is generally easier to audit and maintain.

---

## Multi-Stage Builds

The Dockerfile uses a multi-stage architecture to isolate build-time activities from the published runtime image.

Builder stages are responsible for:

* downloading artifacts;
* extracting archives;
* preparing SDKs.

Only the required runtime components are copied into the final image.

This prevents temporary files, build tools, and intermediate artifacts from becoming part of the published development environment.

---

## Verified Builds

Every image is validated before publication through the project's build verification process.

Verification confirms that:

* required software is installed;
* expected versions are present;
* helper commands function correctly;
* runtime configuration is valid.

Images that fail verification are rejected during the build.

This automated validation reduces the likelihood of distributing incomplete or inconsistent environments.

---

## Health Monitoring

In addition to build verification, the development container provides runtime health checks.

These checks periodically confirm that:

* the environment remains operational;
* required tools are accessible;
* helper commands continue to function correctly.

Continuous health monitoring complements build-time validation by detecting issues that may arise after the container has started.

---

## Package Management

Software is installed from trusted and well-established sources appropriate to each ecosystem.

Examples include:

* Ubuntu package repositories.
* Official language runtime distributions.
* Official GitHub release artifacts.
* Verified package managers.

The project avoids downloading software from untrusted or undocumented sources.

Where practical, installation methods follow vendor recommendations and established community best practices.

---

## Secure Defaults

The development environment is configured with secure defaults wherever practical.

Examples include:

* UTF-8 locale configuration.
* Controlled environment variables.
* Project-local Python virtual environments.
* Non-interactive package installation.
* Predictable runtime configuration.

These defaults reduce the likelihood of configuration errors while maintaining a consistent developer experience.

---

## Infrastructure as Code

All infrastructure required to build the development environment is maintained within the repository.

This includes:

* Dockerfile.
* Version management.
* Build scripts.
* Helper commands.
* Documentation.
* CI workflows.

Infrastructure changes are therefore:

* version controlled;
* peer reviewed;
* reproducible;
* auditable.

Treating infrastructure as code improves both security and maintainability.

---

## Dependency Updates

Keeping dependencies current is an important aspect of maintaining a secure development environment.

The recommended update workflow is:

1. Update `config/versions.yaml`.
2. Regenerate `config/versions.lock`.
3. Rebuild the development image.
4. Execute `baobab-verify`.
5. Review the resulting changes before publication.

Because all managed versions originate from a single source of truth, updates remain straightforward and transparent.

---

## Secrets Management

The BAOBAB Development Container is designed so that secrets are **not** embedded into the image.

Examples include:

* API keys.
* Access tokens.
* Private certificates.
* Cloud credentials.
* Database passwords.

Instead, secrets should be provided at runtime using mechanisms appropriate to the development environment, such as:

* environment variables;
* Docker secrets (where applicable);
* GitHub Codespaces secrets;
* Visual Studio Code Dev Container environment configuration.

Keeping secrets outside the image ensures they are not distributed with the development environment or committed to version control.

---

## Security Responsibilities

The BAOBAB Development Container provides a secure and reproducible foundation, but maintaining a secure development environment is a shared responsibility.

Developers should:

* Keep the development container up to date.
* Rebuild rather than manually modifying containers.
* Avoid installing unnecessary global software.
* Protect credentials and access tokens.
* Report potential security issues promptly.
* Follow secure coding and dependency management practices.

---

## Security Limitations

It is important to recognize what the development container is—and is not—designed to protect.

The container:

* **does** provide a standardized and reproducible development environment;
* **does** reduce configuration drift and unnecessary software exposure;
* **does not** replace endpoint security, vulnerability scanning, or secure application design;
* **does not** guarantee the security of application code developed within it.

Application security remains the responsibility of each individual project.

---

## Summary

Security within the BAOBAB Development Container is achieved through deliberate architectural choices rather than isolated features. Deterministic version management, multi-stage builds, non-root execution, automated verification, minimal software inclusion, and infrastructure as code work together to provide a secure, maintainable, and reproducible development environment. By combining these practices with responsible operational workflows, the project establishes a strong security foundation while remaining focused on developer productivity.
