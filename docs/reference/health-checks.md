---
title: Health Checks
description: Understand the validation and health checks that help confirm BAOBAB is working correctly.
---

# Health Checks

The BAOBAB Development Container includes health checks that help determine whether the development environment is functioning as expected. Unlike build verification, which validates the image during construction, health checks assess the operational state of a running container.

Together, build verification and runtime health checks provide confidence that the development environment is both correctly built and continuously usable.

---

## Philosophy

The project distinguishes between two complementary concepts:

* **Build Verification** answers the question: *Was the image built correctly?*
* **Health Checks** answer the question: *Is the running environment healthy?*

This separation allows each mechanism to focus on a specific stage of the container lifecycle.

---

## Health Check Objectives

A healthy development container should satisfy several conditions:

* The container is running successfully.
* The runtime environment is correctly configured.
* Essential development tools are available.
* Helper commands execute successfully.
* The development user is properly configured.

Health checks are intentionally lightweight and should execute quickly without modifying the container state.

---

## Docker Health Check

The Dockerfile defines a `HEALTHCHECK` instruction that periodically evaluates the runtime environment.

A typical implementation invokes the project's verification command:

```dockerfile id="n2d7qm"
HEALTHCHECK CMD baobab-verify || exit 1
```

This allows Docker and compatible container platforms to determine whether the development environment remains operational.

If the verification command succeeds, the container is reported as **healthy**.

If verification fails, the container is reported as **unhealthy**.

---

## What Is Checked?

Runtime health checks focus on the continued availability of the development environment rather than installation correctness.

Typical checks include:

### Runtime Availability

* Container is operational.
* Shell environment loads correctly.
* Required executables are accessible.

---

### Development Toolchain

Health checks confirm that essential tools remain available.

Examples include:

* Python
* Node.js
* Flutter
* Git
* Docker CLI
* Poetry
* uv

The objective is to detect missing or corrupted components that could prevent productive development.

---

### Helper Commands

The BAOBAB helper commands form part of the supported runtime interface.

Health checks confirm that commands such as:

* `baobab-summary`
* `baobab-verify`

remain executable.

---

### Environment Configuration

Runtime configuration is also validated.

Typical checks include:

* environment variables;
* executable search path (`PATH`);
* user permissions;
* working directory accessibility.

These checks help ensure that the container behaves consistently throughout its lifetime.

---

## Health Status

Docker reports one of three health states for a container:

| Status      | Meaning                                           |
| ----------- | ------------------------------------------------- |
| `starting`  | Health check initialization is in progress        |
| `healthy`   | The container passed the most recent health check |
| `unhealthy` | One or more health checks failed                  |

This status can be inspected using standard Docker commands and may also be consumed by orchestration platforms.

---

## Relationship to Build Verification

Although both mechanisms use the same verification logic, they serve different purposes.

| Build Verification                           | Runtime Health Check                    |
| -------------------------------------------- | --------------------------------------- |
| Executes during image build                  | Executes while the container is running |
| Prevents invalid images from being published | Detects runtime problems after startup  |
| Executed once per build                      | Executed periodically                   |
| Protects image quality                       | Monitors runtime health                 |

Sharing the same underlying verification command reduces duplication while ensuring consistent validation criteria.

---

## Failure Handling

If a health check fails:

* Docker marks the container as **unhealthy**.
* Diagnostic output should identify the failing component.
* Developers can execute `baobab-verify` manually for additional details.

Example:

```bash id="7smr0n"
baobab-verify
```

Because the verification command produces human-readable diagnostics, troubleshooting typically begins with the same command used during automated health checks.

---

## Best Practices

Health checks should remain:

* Fast.
* Deterministic.
* Non-destructive.
* Independent of external services.
* Focused on shared infrastructure.

They should **not**:

* modify the development environment;
* download software;
* install dependencies;
* depend on network availability;
* require project-specific configuration.

Keeping health checks lightweight ensures that they remain reliable indicators of container health rather than sources of additional complexity.

---

## Monitoring in Development

Although health checks are primarily intended for automation, they also provide value during everyday development.

Developers can use them to:

* confirm that a newly started container is operational;
* validate environment updates;
* troubleshoot unexpected runtime issues;
* verify that the shared development infrastructure remains intact.

Because the same checks are executed across local development, Dev Containers, GitHub Codespaces, and CI environments, health status provides a consistent measure of environment quality regardless of where the container is running.

---

## Summary

Health checks provide continuous validation of the BAOBAB Development Container after it has been built and deployed. By periodically confirming that the runtime environment, development toolchain, helper commands, and configuration remain operational, they complement build verification and help ensure that developers always work within a healthy, dependable environment. Together, build verification and health checks form a comprehensive quality assurance strategy that supports the project's goals of reproducibility, reliability, and maintainability.
