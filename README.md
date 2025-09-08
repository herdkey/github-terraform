# GitHub Terraform

This repository manages the GitHub organization and repository settings with Terraform via Terragrunt. This creates consistent repo settings.

## Authentication
The GitHub provider reads a token from the env variable `GITHUB_TOKEN`. Create an API token with required permission to the organization.

## Per-repo overrides
If a per-repo override is needed, extract the setting into `modules/repo/variables.tf`.
