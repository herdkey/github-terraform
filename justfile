import '.justfiles/base.just'

_direnv_allow_prefix := if ci_mode == "true" {
    'direnv allow && direnv export gha > "$GITHUB_ENV" && '
} else { 'direnv allow && ' }
direnv_allow := _direnv_allow_prefix + 'eval "$(direnv export bash)"'

# Only works for local right now (CI not using just yet)

_tg-run *ARGS:
    #!/usr/bin/env bash
    set -euo pipefail

    cd "{{justfile_dir()}}/live"
    eval "{{direnv_allow}}"

    # load pem file
    export GITHUB_APP_PEM_FILE="$(cat "$GITHUB_APP_PEM_FILE_PATH")"

    # eval is used as a hack to make IntelliJ syntax highlighting work
    eval terragrunt "{{ARGS}}"

# Init from local
[group('terragrunt')]
init *ARGS: (_tg-run "init" ARGS)

# Plan from local
[group('terragrunt')]
plan *ARGS: (_tg-run "plan" "-lock=false" ARGS)

[group('terragrunt')]
apply *ARGS: (_tg-run "apply" ARGS)

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
