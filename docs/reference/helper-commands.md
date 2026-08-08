---
title: Helper Commands
description: Find the helper commands and scripts that simplify BAOBAB maintenance and troubleshooting.
---

# Helper Commands

The BAOBAB Development Container includes a set of built-in helper commands that simplify common development tasks and provide a consistent operational interface across all supported environments.

These commands encapsulate project-specific initialization, configuration, verification, and reporting logic behind stable command-line interfaces. By standardizing common operations, developers can perform routine tasks without needing to remember implementation details or script locations.

All helper commands are installed into the container's `PATH` during the image build and are available immediately after the container starts.

---

## Philosophy

The helper commands are designed around three principles:

* **Simple** — easy to discover and remember.
* **Consistent** — the same commands work in every supported environment.
* **Self-documenting** — each command performs a single, well-defined task.

Developers should interact with these commands rather than invoking implementation scripts directly.

---

## Available Commands

The development container currently provides the following helper commands:

| Command              | Purpose                                       |
| -------------------- | --------------------------------------------- |
| `baobab-bootstrap`   | Initialize the development environment        |
| `baobab-post-create` | Perform post-creation setup tasks             |
| `baobab-summary`     | Display environment and toolchain information |
| `baobab-verify`      | Validate the development environment          |

Together, these commands support the complete lifecycle of a development workspace.

---

## `baobab-bootstrap`

The bootstrap command prepares a newly created development environment for use.

Typical responsibilities include:

* validating the runtime environment;
* preparing configuration;
* performing initial setup tasks;
* invoking additional initialization logic where appropriate.

In most workflows, this command is executed automatically during environment provisioning, although it can also be run manually if required.

Example:

```bash id="b5m7pk"
baobab-bootstrap
```

---

## `baobab-post-create`

This command performs post-creation tasks after a development container or Codespace has been provisioned.

Typical activities include:

* final environment configuration;
* workspace initialization;
* developer-specific setup;
* project initialization hooks.

It is commonly configured as a Dev Container or Codespaces lifecycle hook and normally requires no manual intervention.

Example:

```bash id="1z42j8"
baobab-post-create
```

---

## `baobab-summary`

The summary command provides a concise overview of the current development environment.

Typical information displayed includes:

* operating system information;
* image version;
* installed language runtimes;
* development tool versions;
* Flutter installation details;
* Docker tooling;
* BAOBAB image metadata.

Example:

```bash id="r0nh0e"
baobab-summary
```

This command is particularly useful for:

* confirming installed software;
* collecting troubleshooting information;
* verifying environment updates;
* documenting development environments.

Because the output is designed for human consumption, it provides a quick snapshot of the complete toolchain without requiring developers to inspect individual tools manually.

---

## `baobab-verify`

The verification command validates that the development environment has been installed and configured correctly.

Typical verification checks include:

* required software is installed;
* expected tool versions are available;
* helper commands are accessible;
* runtime configuration is correct;
* required environment variables are present;
* user configuration is valid.

Example:

```bash id="3u0e95"
baobab-verify
```

If any required component is missing or incorrectly configured, the command returns a non-zero exit status, making it suitable for both interactive use and automated validation.

This command is executed during the Docker image build to ensure that published images meet project expectations before distribution.

---

## Command Availability

All helper commands are available in every supported environment, including:

* Local Docker development
* Visual Studio Code Dev Containers
* GitHub Codespaces
* Continuous Integration pipelines

Developers can rely on these commands behaving consistently regardless of where the development environment is running.

---

## Design Considerations

The helper command interface intentionally abstracts implementation details.

Internally, commands may invoke shell scripts, perform environment checks, or execute project-specific logic. However, these implementation details remain hidden behind a stable public interface.

This approach provides several benefits:

* implementation can evolve without changing developer workflows;
* automation scripts remain stable over time;
* documentation references consistent command names;
* contributors can improve internal behavior without affecting users.

---

## Extending the Command Set

As the BAOBAB platform evolves, additional helper commands may be introduced to support new workflows.

Examples could include commands for:

* environment diagnostics;
* dependency management;
* documentation generation;
* project maintenance;
* release preparation.

Any new command should:

* perform one clearly defined task;
* follow the existing `baobab-*` naming convention;
* provide consistent output;
* return meaningful exit codes;
* include documentation alongside its implementation.

Maintaining these conventions ensures that the helper command suite remains intuitive and scalable.

---

## Best Practices

To get the most value from the helper commands:

* Use the published commands instead of invoking scripts directly.
* Execute `baobab-verify` after rebuilding or updating the development container.
* Use `baobab-summary` when reporting issues or confirming installed software.
* Allow lifecycle commands such as `baobab-bootstrap` and `baobab-post-create` to run automatically whenever possible.
* Treat the helper commands as the supported interface to the development environment.

---

## Summary

The BAOBAB helper commands provide a simple, consistent, and maintainable interface for interacting with the development environment. By encapsulating common operational tasks behind well-defined commands, the project reduces complexity, improves automation, and delivers a consistent developer experience across local workstations, GitHub Codespaces, Visual Studio Code Dev Containers, and continuous integration systems.
