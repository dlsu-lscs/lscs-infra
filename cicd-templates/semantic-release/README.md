# Semantic Release CI/CD Templates

This directory contains a set of GitHub Actions workflows to set up a complete CI/CD pipeline with automated versioning and releases using `semantic-release`.

## Features
- **Continuous Integration:** Lints, tests, and scans your code on every push and pull request.
- **Containerization:** Builds and pushes a Docker image to GitHub Container Registry.
- **Automated Releases:** Automatically creates versioned GitHub releases with a changelog based on your commit messages.
- **Continuous Deployment:** Triggers deployments to different environments based on the release type (e.g., pre-releases to staging, stable releases to production).

## How to use

Follow these steps to set up the CI/CD pipeline in your new repository.

### Step 1: Copy Workflow Files

Copy all the YAML files from this directory (`001-*.yml`, `002-*.yml`, etc.) into the `.github/workflows/` directory of your repository.

```bash
# From the root of this 'lscs-infra' repository, run:
cp -r cicd-templates/semantic-release/*.yml /new-project-path/.github/workflows/
```

### Step 2: Add the Semantic Release Configuration

Copy the `.releaserc.yml` file to the **root** of your repository.

```bash
# From the root of this 'lscs-infra' repository, run:
cp cicd-templates/semantic-release/.releaserc.yml /new-project-path/
```

This file is crucial as it configures `semantic-release`. It **must** be placed in the root of your project for `semantic-release` to find it.

### Step 3: Configure Repository Secrets

This pipeline requires some secrets to be set up in your GitHub repository settings. Go to `Settings > Secrets and variables > Actions` and add the following repository secrets:

- **For Deployment (choose your platform):**
    - **Coolify:**
        - `COOLIFY_WEBHOOK`: The deployment webhook URL from your Coolify service.
        - `COOLIFY_TOKEN`: Your Coolify API token.
    - **DigitalOcean App Platform:**
        - `DIGITALOCEAN_ACCESS_TOKEN`: Your DigitalOcean API token.
        - `DO_APP_ID`: The ID of your App Platform application.
    - **SSH to a VM:**
        - `HOST`: The IP address or hostname of your server.
        - `USER`: The username for SSH login (e.g., `root`).
        - `PRIVATE_SSH_KEY`: The private SSH key to access your server.

### Step 4: Adopt Conventional Commits

This is the most important part of using `semantic-release`. Your team must follow the **[Conventional Commits specification](https://www.conventionalcommits.org/)** for all commits that are merged into the `main` branch.

The automated release process relies entirely on this convention to determine the version bumps and generate changelogs.

**Commit Message Examples:**

- `feat: Add user profile page` (triggers a `minor` release)
- `fix: Prevent crash when user data is missing` (triggers a `patch` release)
- `docs: Explain the new authentication flow` (no release)
- `ci: Update semantic-release workflow` (no release)
- `feat(api)!: Remove deprecated v1 endpoints` (triggers a `major` release because of the `!`)

## Workflow Explanation

Here is a brief overview of the workflow files:

- **`001-setup-lint-test-scan.yml`**: Runs on every push and pull request to `main`, `dev`, and `staging`. It installs dependencies, and runs linters, tests, and security scans.
- **`002-build-push-image.yml`**: Runs after the `001` workflow succeeds on the `main` branch. It builds a Docker image and pushes it to the GitHub Container Registry.
- **`003-semantic-release.yml`**: Runs after the `002` workflow succeeds. It analyzes your commit messages, determines the next version, and creates a new GitHub Release with a changelog.
- **`004-trigger-deployment.yml`**: Runs when a new release is published. It triggers your deployment process. It can distinguish between pre-releases (for staging/dev) and full releases (for production).
