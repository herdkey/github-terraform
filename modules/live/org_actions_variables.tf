# Organization-level GitHub Actions variables
# These are available to all repositories in the organization
resource "github_actions_organization_variable" "infra_aws_account_id" {
  variable_name = "AWS_ACCOUNT_ID_INFRA"
  visibility    = "all"
  value         = var.infra_account_id
}

resource "github_actions_organization_variable" "test_aws_account_id" {
  variable_name = "AWS_ACCOUNT_ID_TEST"
  visibility    = "all"
  value         = "024441264248"
}

resource "github_actions_organization_variable" "aws_region" {
  variable_name = "AWS_REGION"
  value         = "us-west-2"
  visibility    = "all"
}
