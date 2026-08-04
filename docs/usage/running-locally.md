---
title: Running Locally
description: Set up BAOBAB on your workstation and run the development container locally with Docker.
---

# Running Locally

The BAOBAB Development Container is designed to provide a consistent development environment on any workstation capable of running Docker. Whether using Linux, macOS, or Windows, developers interact with the same container image, ensuring a predictable and reproducible development experience.

Running the container locally allows developers to work with the exact environment used in GitHub Codespaces and supported CI pipelines, minimizing environment-specific issues and simplifying collaboration.

---

## Prerequisites

Before using the BAOBAB Development Container locally, ensure the following software is installed:

* Docker Engine or Docker Desktop
* Docker Buildx
* Git
* A supported code editor (recommended: Visual Studio Code)

For the best experience, Docker BuildKit should be enabled, as the image is optimized to take advantage of advanced caching and multi-stage build features.

---

## Clone the Repository

Begin by cloning the BAOBAB Development Container repository.

```bash
git clone <repository-url>
cd baobab-dev
```

If you are using the container to develop another BAOBAB project, clone that project as well. The development container is designed to host project source code rather than include it within the image.

---

## Build the Development Image

Before building the image, ensure that the version lock file has been generated.

The typical workflow is:

1. Update `config/versions.yaml` (if required).
2. Run the version resolution process.
3. Build the Docker image.

For example:

```bash
./config/resolve.sh
docker build -t baobab-dev .
```

The build process will:

* prepare builder stages;
* install the operating system packages;
* install language runtimes;
* configure the development environment;
* execute build verification.

If verification fails, the build terminates with an error, preventing an invalid image from being used.

---

## Run the Container

Once the image has been built successfully, start an interactive development session.

Example:

```bash
docker run --rm -it \
    -v "$(pwd):/workspace" \
    baobab-dev
```

This mounts the current working directory into the container, allowing source code to remain on the host while development occurs inside the standardized environment.

Projects may choose to mount additional directories or volumes depending on their development workflow.

---

## Verify the Environment

After entering the container, verify that the development environment is functioning correctly.

Run:

```bash
baobab-verify
```

A successful verification confirms that:

* required software is installed;
* expected runtime versions are available;
* helper commands are functioning correctly;
* the environment is configured as intended.

Developers can also inspect the installed toolchain using:

```bash
baobab-summary
```

This provides a concise overview of the development environment and installed components.

---

## Working with Projects

The development container is intentionally independent of any individual BAOBAB application.

Typical workflows involve:

* cloning the project repository;
* opening the project inside the container;
* installing project-specific dependencies;
* beginning development.

Examples include:

* `poetry install`
* `pnpm install`
* `flutter pub get`

Project dependencies remain part of the project itself and are not baked into the shared development image.

---

## Updating the Development Environment

When a new version of the development container is released, update your local environment by:

1. Pulling the latest repository changes.
2. Regenerating `config/versions.lock` if required.
3. Rebuilding the Docker image.
4. Recreating any existing development containers.

Because the environment is fully defined as code, rebuilding is the preferred method of applying updates rather than modifying existing containers manually.

---

## Troubleshooting

If the container does not behave as expected:

1. Ensure Docker is running.
2. Verify that BuildKit is enabled.
3. Rebuild the image without using stale layers if necessary.
4. Execute:

```bash
baobab-verify
```

5. Review the Docker build logs for any verification failures.
6. Confirm that the generated `config/versions.lock` matches the intended software versions.

Because the development environment is deterministic, reproducing issues is typically straightforward. Rebuilding from a clean state often resolves problems caused by outdated images or cached artifacts.

---

## Best Practices

For the most consistent local development experience:

* Treat the container as disposable.
* Keep project source code outside the image.
* Avoid manually modifying the container.
* Rebuild rather than patch existing images.
* Commit version configuration changes alongside regenerated lock files.
* Verify the environment after significant updates.

Following these practices ensures that every developer works from the same reproducible foundation and that local environments remain aligned with GitHub Codespaces and continuous integration pipelines.

---

Running the BAOBAB Development Container locally provides a reliable, reproducible development environment that closely mirrors cloud-hosted and automated workflows. By combining deterministic builds, standardized tooling, and automated verification, developers can focus on building software rather than managing workstation configuration.
