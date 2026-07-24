
# BAOBAB Enterprise Dev Container

The standard, enterprise-grade development environment for every BAOBAB
Enterprise Platform engineer, maintained by **Nabhold Group Africa —
Platform Engineering**.

Published image: `ghcr.io/nabhold-group-africa/baobab-devcontainer`

---

## 1. What's inside

| Category        | Tooling |
|------------------|---------|
| Base OS          | Ubuntu 26.04 LTS ("Resolute Raccoon") |
| Python           | Python 3.14 (deadsnakes-pinned), pip, venv, pipx, [uv](https://github.com/astral-sh/uv), Poetry (in-project venvs) |
| JavaScript       | Node.js 24.x LTS, npm, pnpm, yarn (via Corepack) |
| Mobile           | Flutter (stable) + bundled Dart SDK |
| Databases (clients only) | PostgreSQL 17 client (`psql`), Redis CLI (`redis-cli`) |
| Containers       | Docker CLI, Docker Compose plugin, Buildx plugin — **no daemon** |
| GitHub           | GitHub CLI (`gh`) |
| Shell utilities  | ripgrep, fd, bat, eza, fzf, tmux, bash-completion |
| Editor           | Preconfigured VS Code extensions & settings for Python, Ruff, Black, isort, mypy, Docker, Flutter/Dart, GitHub Actions, Markdown, YAML |
| User             | `vscode` (UID/GID 1000), passwordless sudo, bash default shell |

### What's intentionally NOT included

- **Docker daemon / containerd** — Codespaces and local Dev Containers both
  provide a host Docker socket; this image only ships the CLI and talks to
  that socket (see `docker-outside-of-docker` feature in `devcontainer.json`).
- **Android SDK / Xcode toolchains** — `flutter doctor` will report these as
  missing by design. Mobile builds targeting real devices/emulators should
  use a dedicated mobile CI runner or a local machine; this image covers
  Dart/Flutter *code* development, testing, and web/desktop targets.
- **PostgreSQL / Redis / MinIO / OpenSearch servers** — these run as
  Compose services alongside the devcontainer, not inside it. Only client
  CLIs are installed here.
- **Application-level dependencies** (Django, DRF, django-tenants, Celery,
  FastAPI, Next.js packages, etc.) — these belong to each project's own
  `pyproject.toml` / `package.json` / `pubspec.yaml` and are installed by
  `.devcontainer/post-create.sh` on container creation. This keeps the base
  image reusable across every BAOBAB repository and framework upgrade
  without a rebuild.

---

## 2. Using this image in a project

1. Copy `.devcontainer/devcontainer.json` and `.devcontainer/post-create.sh`
   into your project repository (or add this repo as a git submodule under
   `.devcontainer/`).
2. Confirm the `image:` tag in `devcontainer.json` points at the version you
   want (see [Versioning](#5-versioning-strategy)).
3. Open in VS Code → **Reopen in Container**, or create a GitHub Codespace.
4. `onCreateCommand` / `postCreateCommand` run `post-create.sh`, which
   detects `pyproject.toml`, `package.json`, and `pubspec.yaml` at your repo
   root (and in `frontend/` / `mobile/` subfolders) and installs accordingly.
5. Run `baobab-summary` any time for a snapshot of the environment, and
   `baobab-verify` for a full toolchain health check.

### Onboarding outside of VS Code / Codespaces

If you're bringing up the image directly (bare `docker run`, a CI runner,
etc.), run:

```bash
./scripts/bootstrap.sh
```

This configures git identity, `gh auth`, `.env` scaffolding, and pre-commit
hooks, then delegates to `post-create.sh` for dependency installation. Use
`--non-interactive` in CI.

---

## 3. Building the image locally

Requires Docker with BuildKit (Docker Desktop / Docker Engine ≥ 23, or
`docker buildx` installed standalone).

```bash
# Single-arch, local test build (fast, native arch only)
docker buildx build \
  --load \
  --tag baobab-devcontainer:dev \
  .

# Multi-arch build (what CI does) — requires a buildx builder with the
# docker-container driver, and can't be --load'ed locally (multi-platform
# manifests must be pushed to a registry or built one arch at a time)
docker buildx create --use --name baobab-builder 2>/dev/null || docker buildx use baobab-builder
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  --tag ghcr.io/nabhold-group-africa/baobab-devcontainer:dev \
  --push \
  .
```

Override any pinned version at build time, e.g. to test a Flutter bump:

```bash
docker buildx build --build-arg FLUTTER_VERSION=3.45.0 --load -t baobab-devcontainer:flutter-test .
```

### Verifying a build

```bash
docker run --rm baobab-devcontainer:dev baobab-verify
```

`verify.sh` exits non-zero if any **required** tool is missing/broken —
wire this into any pipeline that builds the image before it's trusted.

---

## 4. Publishing to GitHub Container Registry (GHCR)

Publishing is automated by
`.github/workflows/build-and-publish.yml` and is the supported path for
production releases. Manual publishing (e.g. for a one-off hotfix) works
the same way `docker buildx build --push` does above, but authenticate
first:

```bash
echo "$GITHUB_TOKEN" | docker login ghcr.io -u <your-gh-username> --password-stdin
```

Required repository/organization settings:

- A GHCR package named `baobab-devcontainer` under the
  `nabhold-group-africa` GitHub org, with **Inherit access from repository**
  (or explicit team access) so every BAOBAB engineer's `GITHUB_TOKEN` /
  PAT with `read:packages` can pull it without extra configuration —
  this is what lets `devcontainer.json`'s `image:` field resolve without
  a manual `docker login` inside Codespaces.
- Actions permissions on the repo: **Read and write permissions** for
  `GITHUB_TOKEN` (Settings → Actions → General → Workflow permissions),
  since the workflow pushes packages using the built-in token.
- Branch protection on `main` requiring the `build` job (PR mode) to pass
  before merge, so a broken Dockerfile never reaches a release tag.

### Release flow

```bash
git checkout main && git pull
git tag v1.4.0
git push origin v1.4.0
```

Pushing a `vX.Y.Z` tag triggers the workflow to: build both architectures →
run `baobab-verify` as a smoke test → merge into one multi-arch manifest →
push tags `1.4.0`, `1.4`, `1`, and `latest` → sign each tag with `cosign`
(keyless, via GitHub OIDC) → write a summary of published tags to the
Actions run.

---

## 5. Versioning strategy

This image follows **Semantic Versioning 2.0.0** applied to the
*environment*, not to BAOBAB application code:

| Segment | Bumped when... |
|---------|-----------------|
| **MAJOR** (`X`)   | A change that can break existing projects without action: new Ubuntu LTS base, a Python/Node major bump, removal of a tool, a change to the default user/UID, or any change to `PATH`/env var semantics that isn't purely additive. |
| **MINOR** (`Y`)   | Backward-compatible additions: a new utility, a new VS Code extension, a new pinned tool version within the same major line (e.g. Flutter 3.44 → 3.47), new Compose port forwards. |
| **PATCH** (`Z`)   | Backward-compatible fixes: a corrected apt repo URL, a security patch to the base image, a fixed typo in an alias, a `verify.sh` bug fix. |
| **Pre-release** (`-rc.N`, `-beta.N`) | Published for early testing (e.g. validating a new Ubuntu LTS) without being picked up by `latest` or unpinned `devcontainer.json` references. |

Published tags per release, from most to least specific:

```
ghcr.io/nabhold-group-africa/baobab-devcontainer:1.4.0   # exact — use in production CI
ghcr.io/nabhold-group-africa/baobab-devcontainer:1.4     # latest patch of 1.4.x
ghcr.io/nabhold-group-africa/baobab-devcontainer:1       # latest minor/patch of 1.x.x
ghcr.io/nabhold-group-africa/baobab-devcontainer:latest  # latest stable release overall
```

**Recommendation:** project `devcontainer.json` files should pin the exact
`X.Y.Z` tag (as shown in this repo) and bump it deliberately via PR, never
track `latest`. `latest` exists for ad-hoc/local use and quick trials only.

A `CHANGELOG.md` (Keep a Changelog format) should accompany every tag and
is enforced by the release checklist below.

### Release checklist

1. Update pinned `ARG` versions in `Dockerfile` as needed.
2. Update `CHANGELOG.md`.
3. Open a PR — CI builds (no push) and smoke-tests via `baobab-verify`.
4. Merge to `main`.
5. Tag (`git tag vX.Y.Z && git push origin vX.Y.Z`) — CI builds, signs, and
   publishes.
6. Announce the new tag in the platform-engineering channel with a link to
   the CHANGELOG entry.

---

## 6. Maintenance recommendations

### Ubuntu base image

- Track Canonical's LTS cadence (new LTS every 2 years, in April). Plan a
  **MAJOR** version bump within 3–6 months of a new LTS GA, after
  `apt.postgresql.org`, `download.docker.com`, and `deadsnakes` PPA support
  land for the new codename (they typically lag GA by a few weeks).
  Test in an `-rc` pre-release tag first.
- Between LTS releases, rebuild the *current* major on a schedule (monthly
  is reasonable) via `workflow_dispatch` to pick up base-image security
  patches, and publish as a new PATCH tag even with no Dockerfile change.
- Subscribe to Ubuntu Security Notices (USN) for the pinned release, or run
  `docker scout` / `trivy` against published tags in a scheduled workflow.

### Language runtimes

- **Python**: deadsnakes tracks CPython closely; bump `PYTHON_VERSION`/
  `PYTHON_MINOR` for a new minor release as a MINOR bump once Django,
  DRF, and django-tenants have published compatible releases — check their
  trove classifiers / CI matrices first, since ORMs are typically the
  slowest ecosystem piece to certify a new Python.
- **Node.js**: only track `NODE_MAJOR` values that are **Active LTS**
  (never "Current"). Re-check twice a year (April/October, aligned with
  Node's own release cadence) and bump as a MINOR release.
- **Flutter**: the stable channel ships roughly quarterly. Bump
  `FLUTTER_VERSION` as a MINOR release; treat a Flutter/Dart major bump
  (e.g. an eventual Flutter 4.0) as a platform MAJOR bump and validate
  against BAOBAB's mobile app before rolling out org-wide.
- **PostgreSQL client**: keep the client major aligned with the production
  server major (currently 17). Bumping the client ahead of the server is
  usually safe (clients are backward compatible); never let the client
  fall behind the server major.

### Pinned CLI utilities (ripgrep, fd, bat, eza, GitHub CLI, Docker CLI)

- These are pulled from upstream releases/repos specifically so they don't
  silently drift with `apt-get upgrade`. Bump their `ARG` versions
  quarterly, or immediately for a disclosed CVE, as a PATCH/MINOR release.

### General hygiene

- Keep `.github/workflows/build-and-publish.yml`'s PR-mode build as a
  required status check — it must never regress `baobab-verify`.
- Re-run `docker buildx build --no-cache` at least once per quarter to
  catch silent apt-repo or upstream-URL breakage before a real release
  needs it.
- Review and prune unused VS Code extensions/settings in
  `devcontainer.json` at each MAJOR bump — extension bloat slows Codespace
  prebuilds.
- Keep this README's tool table and the `verify.sh` checklist in sync —
  `verify.sh` is the executable source of truth for "what must exist."

---

## 7. Repository layout

```
.
├── Dockerfile                      # multi-stage image definition
├── config/
│   └── bashrc.d/                   # sourced shell enhancements (prompt, aliases, history)
├── .devcontainer/
│   ├── devcontainer.json           # Codespaces / VS Code Dev Container config
│   └── post-create.sh              # project dependency install (on-create / post-create stages)
├── scripts/
│   ├── bootstrap.sh                # standalone onboarding for non-VS Code usage
│   ├── verify.sh                   # installed as `baobab-verify`
│   └── summary.sh                  # installed as `baobab-summary`
├── .github/workflows/
│   └── build-and-publish.yml       # multi-arch build, sign, and publish to GHCR
└── README.md
```
