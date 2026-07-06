# CI/CD Templates

Language-specific, copy-paste GitHub Actions pipelines for production use. Each template includes pre-commit hooks, linting, testing with coverage gating, security scanning, Docker image building, and Coolify deployment.

## Available Templates

| Language | Lint | Test | Security | Pre-commit |
|----------|------|------|----------|------------|
| [Python](./python/) | ruff + mypy | pytest + coverage | pip-audit + CodeQL + Trivy | ruff, mypy, gitleaks |
| [Go](./go/) | golangci-lint | go test -race + coverage | govulncheck + gosec + Trivy | golangci-lint, go-fmt, gitleaks |
| [Node](./node/) | eslint + prettier | vitest/jest + coverage | npm audit + CodeQL + Trivy | prettier, eslint, gitleaks |

## Quick Start

1. Find your language folder (e.g., `python/`)
2. Copy the relevant files into your project (see language-specific README)
3. Add required GitHub secrets
4. Push and watch the pipeline run

## Pipeline Structure (All Languages)

```
Push/PR to main:
  ┌─────────────────┐
  │  Lint & Format   │  ← Fast feedback
  └────────┬────────┘
           │
  ┌────────┴────────┐
  │  Type Check      │  ← (Go: built into lint, Node: separate)
  └────────┬────────┘
           │
  ┌────────┴────────┐
  │  Test & Coverage │  ← 80% threshold enforced
  └────────┬────────┘
           │
  ┌────────┴────────┐
  │  Security Scan   │  ← pip-audit/npm audit + govulncheck + CodeQL + Trivy
  └────────┬────────┘

Push to main only:
  ┌─────────────────┐
  │  Build & Push    │  ← Docker image → GHCR
  └────────┬────────┘
           │
  ┌────────┴────────┐
  │  Deploy          │  ← Coolify webhook trigger
  └─────────────────┘
```

## Required Secrets (All Templates)

| Secret | Purpose | Required |
|--------|---------|----------|
| `COOLIFY_WEBHOOK_URL` | Coolify deployment webhook URL | Yes |
| `PAT` | GitHub PAT for auto-fix commits | No (future) |

`GITHUB_TOKEN` is used automatically for GHCR image pushes.

## Coverage Gating

All templates enforce an **80% minimum coverage threshold**. Below 80%, the CI pipeline fails.

Coverage reports are uploaded to [Codecov](https://codecov.io) for PR annotations and historical tracking. Configure `CODECOV_TOKEN` as a repository secret if using private repos.

## Auto-fix (Future Feature)

Each template includes a **commented-out auto-fix job** that can push lint/format fixes back to PR branches. To enable:

1. Create a GitHub PAT with `contents: write` scope
2. Add it as a repository secret named `PAT`
3. Uncomment the `auto-fix` job in `001-lint-test-scan.yml`

> **Note:** Auto-fix is commented out by default because it requires a PAT (not `GITHUB_TOKEN`) to push commits back to PRs from forks or protected branches.

## File Naming Convention

- `001-*.yml` — Lint, test, security scanning (runs on push + PR)
- `002-*.yml` — Docker build & push (runs on push to main only)
- `003-*.yml` — Deployment trigger (runs after build succeeds)

## Customization Checklist

Per-language READMEs include specific instructions, but generally:

- [ ] Adjust language/runtime version in workflow files
- [ ] Update package manager commands (npm/pnpm/yarn, pip/uv, go modules)
- [ ] Configure coverage thresholds if 80% doesn't fit
- [ ] Add language-specific linting rules
- [ ] Set up `CODECOV_TOKEN` for private repos
- [ ] Configure branch protection rules to require CI passing

## Future Improvements

- [ ] Java/Spring Boot template
- [ ] CI polling mechanism for long-running tests
- [ ] Integration test containers (testcontainers.com)
- [ ] Multi-platform Docker builds (amd64 + arm64)
- [ ] SBOM generation and signing (cosign)
- [ ] Matrix strategy for multiple runtime versions
- [ ] Terraform/infrastructure pipeline templates
