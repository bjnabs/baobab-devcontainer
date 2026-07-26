# Contributing

Contributions are welcome and play an important role in the continued evolution of the BAOBAB Development Container. Whether improving documentation, refining the Dockerfile, enhancing automation, or introducing new capabilities, every contribution should support the project's core principles of simplicity, reproducibility, and maintainability.

This document outlines the expectations and workflow for contributing to the project.

---

## Guiding Principles

Every contribution should align with the architectural principles established throughout this repository.

In particular, contributors should strive to:

* Preserve deterministic builds.
* Maintain a clear separation of concerns.
* Keep the Dockerfile focused on infrastructure.
* Centralize version management.
* Prefer simplicity over cleverness.
* Document architectural decisions.
* Improve maintainability without sacrificing clarity.

When evaluating a proposed change, ask:

> **Will this make the development container easier to understand, maintain, and reproduce?**

If the answer is no, reconsider the implementation.

---

## Before You Begin

Before making changes, ensure that you:

1. Read this documentation.
2. Understand the project's design principles.
3. Familiarize yourself with the version management workflow.
4. Build the development container successfully.
5. Verify the environment using:

```bash id="tpkmfy"
baobab-verify
```

A working baseline makes it easier to validate subsequent changes.

---

## Development Workflow

The recommended contribution workflow is:

```text id="qz9v4d"
Fork Repository
        │
        ▼
Create Feature Branch
        │
        ▼
Implement Changes
        │
        ▼
Update Documentation
        │
        ▼
Build Container
        │
        ▼
Run Verification
        │
        ▼
Submit Pull Request
```

Following a consistent workflow simplifies code reviews and helps maintain project quality.

---

## Coding Standards

Infrastructure should be written with readability as the primary objective.

Contributors should:

* Write clear, self-explanatory code.
* Prefer explicit behavior over implicit assumptions.
* Keep functions and scripts focused on a single responsibility.
* Avoid unnecessary complexity.
* Add comments that explain *why*, not *what*.

Future maintainers should be able to understand the implementation without reverse-engineering it.

---

## Dockerfile Guidelines

When modifying the Dockerfile:

* Keep build stages focused on a single responsibility.
* Avoid introducing duplicate logic.
* Minimize image layers where practical.
* Preserve BuildKit optimizations.
* Do not resolve software versions during the build.
* Keep architecture-specific logic isolated.
* Remove temporary artifacts before publishing the image.

The Dockerfile should remain a consumer of configuration, not a source of configuration.

---

## Version Management

Software versions must be managed through the project's version management process.

When updating shared tooling:

1. Modify `config/versions.yaml`.
2. Regenerate `config/versions.lock`.
3. Review both files.
4. Rebuild the image.
5. Verify the completed environment.

Avoid introducing hard-coded version numbers into the Dockerfile or helper scripts.

---

## Documentation

Documentation is considered part of the implementation.

Contributors should update documentation whenever they:

* add new features;
* change workflows;
* modify helper commands;
* alter configuration;
* introduce architectural changes.

A pull request is generally considered incomplete if it changes behavior without updating the corresponding documentation.

---

## Testing

Every contribution should be validated before submission.

At a minimum:

1. Build the development container.
2. Execute:

```bash id="c5rxx6"
baobab-verify
```

3. Review:

```bash id="0qktjp"
baobab-summary
```

4. Confirm that the affected functionality behaves as expected.

Where appropriate, contributors should also verify changes in:

* Local Docker
* Visual Studio Code Dev Containers
* GitHub Codespaces
* Continuous Integration

---

## Pull Requests

Well-prepared pull requests are easier to review and more likely to be accepted.

A good pull request should:

* Focus on a single logical change.
* Include a clear description of the motivation.
* Explain any architectural decisions.
* Reference related issues where applicable.
* Include documentation updates.
* Pass all automated verification.

Large, unrelated changes should be split into separate pull requests whenever practical.

---

## Commit Messages

Write commit messages that clearly describe **why** a change was made.

Examples:

```text id="3ffgvg"
Refactor Flutter installation into dedicated builder stage

Centralize runtime version management

Improve verification of helper commands

Document image architecture
```

Clear commit history makes future maintenance and troubleshooting significantly easier.

---

## Reporting Issues

If you discover a bug or unexpected behavior, include as much useful information as possible.

Helpful information includes:

* BAOBAB image version
* Operating system
* Processor architecture
* Docker version
* Build logs
* Output from:

```bash id="tkjpd8"
baobab-summary
```

and

```bash id="t13sp8"
baobab-verify
```

Providing reproducible information greatly improves the ability to diagnose and resolve issues.

---

## Code Review Expectations

All contributions should undergo review before being merged.

Reviews focus on:

* correctness;
* maintainability;
* readability;
* architectural consistency;
* documentation quality;
* reproducibility.

Constructive feedback is an essential part of maintaining a high-quality project and should be viewed as a collaborative process.

---

## Contributor Responsibilities

Contributors are expected to:

* Follow the documented architecture.
* Preserve deterministic behavior.
* Avoid unnecessary dependencies.
* Keep changes focused and well documented.
* Respect existing project conventions.
* Test changes before submission.

These responsibilities help ensure that the project remains reliable as it evolves.

---

## Summary

The BAOBAB Development Container is built to be maintainable over the long term, and thoughtful contributions are essential to achieving that goal. By following the project's architectural principles, maintaining deterministic builds, documenting changes, and validating every contribution through automated verification, contributors help preserve a development environment that is consistent, reliable, and easy to evolve for the entire engineering team.
