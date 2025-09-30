# GitHub Terraform

This repository manages the GitHub organization and repository settings with Terraform via Terragrunt. This creates consistent repo settings.

## Authentication

### Using a GitHub App (recommended)
We have created 2 GitHub Apps for this purpose:
1. [Savi GitHub Terraform (Apply)](https://github.com/organizations/herdkey/settings/apps/savi-github-terraform-apply)
2. [Savi GitHub Terraform (Plan)](https://github.com/organizations/herdkey/settings/apps/savi-github-terraform-plan)

In this app, we have generated a private key and stored it (base64-encoded) as a secret in this repo's secrets. We pasted the result of `base64 -i "$PEM_FILE_PATH" | pbcopy` into the environment secret `APP_PRIVATE_KEY_B64` in:
- this repo's `infra` environment, if it is the secret for the _Savi GitHub Terraform_ app
- the repository secrets, if it is the secret for the _Savi GitHub Terraform (Read-Only)_ app

If you need to run the terraform locally for any reason, initialize these variables before running any terraform commands:
- `GITHUB_APP_ID`
- `GITHUB_APP_INSTALLATION_ID`
- `GITHUB_APP_PEM_FILE` (the actual contents of the PEM file, not a path to the file)

### Using a PAT (Personal Access Token)
Alternatively, the GitHub provider will read a token from the env variable `GITHUB_TOKEN`. Create an API token with required permission to the organization. Look at the app's permissions to see what is needed. PATs are generally discouraged.
