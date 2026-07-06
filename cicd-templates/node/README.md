# Node.js / JavaScript / TypeScript CI/CD Template

Production-ready GitHub Actions pipeline for Node.js projects with linting, testing, security scanning, and Coolify deployment.

## Quick Start

1. Copy `.pre-commit-config.yaml` to your repo root
2. Copy `001-lint-test-scan.yml`, `002-build-push-image.yml`, `003-trigger-deployment.yml` into `.github/workflows/`
3. Add required scripts to your `package.json` (see below)
4. Add required secrets (see below)
5. Install pre-commit hooks: `pre-commit install`

## Required package.json Scripts

```json
{
  "scripts": {
    "lint": "eslint .",
    "test": "vitest run",
    "typecheck": "tsc --noEmit"
  }
}
```

## Required Dev Dependencies

```bash
npm install -D eslint prettier vitest @vitest/coverage-v8 typescript
```

## Pipeline Overview

```
Push/PR → Lint (eslint + prettier) → Type Check (tsc) → Test (vitest + coverage) → Security (npm audit + Trivy)
Push to main → Build & Push Docker Image (GHCR) → Trigger Coolify Deployment
```

## Required Secrets

| Secret | Purpose |
|--------|---------|
| `COOLIFY_WEBHOOK_URL` | Coolify deployment webhook URL |
| `PAT` | (Optional) Personal access token for auto-fix commits |

## Customization

- **Node version**: Change `node-version` in workflow files (matrix: 20, 22)
- **Package manager**: Replace `npm ci` with `pnpm install --frozen-lockfile` or `yarn --frozen-lockfile`
- **Test framework**: Replace `vitest` with `jest` in test commands
- **Coverage threshold**: Configure in `vitest.config.ts` or `jest.config.js`

## Auto-fix (Future)

The `001-lint-test-scan.yml` includes a commented-out auto-fix job. To enable:
1. Create a PAT with `contents: write` scope
2. Add it as a repository secret named `PAT`
3. Uncomment the `auto-fix` job in the workflow

## File Overview

| File | Purpose |
|------|---------|
| `.pre-commit-config.yaml` | Pre-commit hooks (prettier, eslint, gitleaks) |
| `001-lint-test-scan.yml` | CI pipeline: lint, type check, test, security scan |
| `002-build-push-image.yml` | Build Docker image and push to GHCR |
| `003-trigger-deployment.yml` | Trigger Coolify deployment via webhook |
