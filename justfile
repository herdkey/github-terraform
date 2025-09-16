# Use bash and fail immediately on errors
set shell := ["/usr/bin/env", "bash", "-euo", "pipefail", "-c"]

# -----------------------------------------------------------------------------
# Repository-wide helpers
# -----------------------------------------------------------------------------

# Format Terraform code in the entire repo
fmt:
    tofu fmt -recursive
    terragrunt hcl fmt

lint:
    tflint --recursive --config="$(pwd)/.tflint.hcl" --fix

nuke-cache:
    # https://terragrunt.gruntwork.io/docs/reference/terragrunt-cache/#clearing-the-terragrunt-cache
    find . -type d -name ".terragrunt-cache" -prune -exec rm -rf {} \;
