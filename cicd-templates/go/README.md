# Go CI/CD Template

Production-ready GitHub Actions pipeline for Go projects with linting, testing, security scanning, and Coolify deployment.

## Quick Start

1. Copy `.pre-commit-config.yaml` and `.golangci.yml` to your repo root
2. Copy `001-lint-test-scan.yml`, `002-build-push-image.yml`, `003-trigger-deployment.yml` into `.github/workflows/`
3. Add required secrets (see below)
4. Install pre-commit hooks: `pre-commit install`

## Pipeline Overview

```
Push/PR → Lint (golangci-lint + go vet) → Test (go test -race + coverage) → Security (govulncheck + gosec + Trivy)
Push to main → Build & Push Docker Image (GHCR) → Trigger Coolify Deployment
```

## Required Secrets

| Secret | Purpose |
|--------|---------|
| `COOLIFY_WEBHOOK_URL` | Coolify deployment webhook URL |
| `PAT` | (Optional) Personal access token for auto-fix commits |

## Customization

- **Go version**: Change `go-version` in workflow files
- **Linters**: Edit `.golangci.yml` to enable/disable linters
- **Build flags**: Edit `go test` args in `001-lint-test-scan.yml`
- **Module path**: Ensure `go.mod` module path matches your repo

## Auto-fix (Future)

The `001-lint-test-scan.yml` includes a commented-out auto-fix job. To enable:
1. Create a PAT with `contents: write` scope
2. Add it as a repository secret named `PAT`
3. Uncomment the `auto-fix` job in the workflow

## File Overview

| File | Purpose |
|------|---------|
| `.pre-commit-config.yaml` | Pre-commit hooks (golangci-lint, go-fmt, gitleaks) |
| `.golangci.yml` | golangci-lint configuration |
| `001-lint-test-scan.yml` | CI pipeline: lint, test, security scan |
| `002-build-push-image.yml` | Build Docker image and push to GHCR |
| `003-trigger-deployment.yml` | Trigger Coolify deployment via webhook |
