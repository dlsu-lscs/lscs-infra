# Python CI/CD Template

Production-ready GitHub Actions pipeline for Python projects with linting, testing, security scanning, and Coolify deployment.

## Quick Start

1. Copy `.pre-commit-config.yaml` to your repo root
2. Copy `001-lint-test-scan.yml`, `002-build-push-image.yml`, `003-trigger-deployment.yml` into `.github/workflows/`
3. Copy relevant sections from `pyproject.toml` into your project's `pyproject.toml`
4. Add required secrets (see below)
5. Install pre-commit hooks: `pre-commit install`

## Pipeline Overview

```
Push/PR → Lint (ruff + mypy) → Test (pytest + coverage 80%) → Security (pip-audit + CodeQL + Trivy)
Push to main → Build & Push Docker Image (GHCR) → Trigger Coolify Deployment
```

## Required Secrets

| Secret | Purpose |
|--------|---------|
| `COOLIFY_WEBHOOK_URL` | Coolify deployment webhook URL |
| `PAT` | (Optional) Personal access token for auto-fix commits |

## Customization

- **Coverage threshold**: Edit `--fail-under=80` in `001-lint-test-scan.yml`
- **Python version**: Change `python-version` in workflow files
- **Ruff rules**: Edit `select` list in `pyproject.toml`
- **Test paths**: Edit `testpaths` in `pyproject.toml`

## Auto-fix (Future)

The `001-lint-test-scan.yml` includes a commented-out auto-fix job. To enable:
1. Create a PAT with `contents: write` scope
2. Add it as a repository secret named `PAT`
3. Uncomment the `auto-fix` job in the workflow

## File Overview

| File | Purpose |
|------|---------|
| `.pre-commit-config.yaml` | Pre-commit hooks (ruff, mypy, gitleaks) |
| `001-lint-test-scan.yml` | CI pipeline: lint, test, security scan |
| `002-build-push-image.yml` | Build Docker image and push to GHCR |
| `003-trigger-deployment.yml` | Trigger Coolify deployment via webhook |
| `pyproject.toml` | Ruff, pytest, coverage, mypy config snippets |
