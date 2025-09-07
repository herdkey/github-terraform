# TFLint configuration for this repository
# See: https://github.com/terraform-linters/tflint

config {
  force               = false
  disabled_by_default = false
}

# rules: https://github.com/terraform-linters/tflint-ruleset-terraform/blob/main/docs/rules/README.md
plugin "terraform" {
  enabled = true
  preset  = "recommended"
}
