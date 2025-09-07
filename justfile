# Use bash with strict-ish mode for safety
set shell := ["bash", "-uc"]

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
