locals {
  # Private repos cannot use protection rules until we upgrade to GitHub Teams.
  enable_protection = github_repository.this.visibility == "public"
}

data "github_user" "prod_reviewer" {
  for_each = toset(var.prod_reviewers)
  username = each.value
}


################################################################################
#                                     Play                                     #
################################################################################

resource "github_repository_environment" "play" {
  count               = contains(var.envs, "play") ? 1 : 0
  environment         = "play"
  repository          = github_repository.this.name
  prevent_self_review = false
}

resource "github_actions_environment_variable" "play_aws_account_id" {
  repository    = github_repository.this.name
  environment   = "play"
  variable_name = "AWS_ACCOUNT_ID_LIVE"
  value         = "662682347177"
}

################################################################################
#                                    Stage                                     #
################################################################################

resource "github_repository_environment" "stage" {
  count               = contains(var.envs, "stage") ? 1 : 0
  environment         = "stage"
  repository          = github_repository.this.name
  prevent_self_review = false

  # We can only include this block in public repos, until we upgrade to GitHub Teams
  dynamic "deployment_branch_policy" {
    for_each = local.enable_protection ? [true] : []
    content {
      # NOTE: protected_branches and custom_branch_policies cannot have the same value
      # https://docs.github.com/en/rest/deployments/environments?apiVersion=2022-11-28#create-or-update-an-environment
      protected_branches     = false
      custom_branch_policies = true
    }
  }
}

resource "github_repository_environment_deployment_policy" "stage" {

  count = contains(var.envs, "stage") && local.enable_protection ? 1 : 0

  repository     = github_repository.this.name
  environment    = github_repository_environment.stage[0].environment
  branch_pattern = "main"
}

resource "github_actions_environment_variable" "stage_aws_account_id" {
  repository    = github_repository.this.name
  environment   = "stage"
  variable_name = "AWS_ACCOUNT_ID_LIVE"
  value         = ""
}


################################################################################
#                                     Prod                                     #
################################################################################

resource "github_repository_environment" "prod" {

  count = contains(var.envs, "prod") ? 1 : 0

  environment         = "prod"
  repository          = github_repository.this.name
  prevent_self_review = false

  dynamic "reviewers" {
    for_each = local.enable_protection ? [true] : []
    content {
      users = [for user in data.github_user.prod_reviewer : user.id]
    }
  }

  dynamic "deployment_branch_policy" {
    for_each = local.enable_protection ? [true] : []
    content {
      protected_branches     = false
      custom_branch_policies = true
    }
  }
}

resource "github_repository_environment_deployment_policy" "prod" {
  count          = contains(var.envs, "prod") && local.enable_protection ? 1 : 0
  repository     = github_repository.this.name
  environment    = github_repository_environment.prod[0].environment
  branch_pattern = "main"
}

resource "github_actions_environment_variable" "prod_aws_account_id" {
  repository    = github_repository.this.name
  environment   = "prod"
  variable_name = "AWS_ACCOUNT_ID_LIVE"
  value         = ""
}

################################################################################
#                                    Infra                                     #
################################################################################

resource "github_repository_environment" "infra" {

  count = contains(var.envs, "infra") ? 1 : 0

  environment         = "infra"
  repository          = github_repository.this.name
  prevent_self_review = false

  dynamic "reviewers" {
    for_each = local.enable_protection ? [true] : []
    content {
      users = [for user in data.github_user.prod_reviewer : user.id]
    }
  }

  dynamic "deployment_branch_policy" {
    for_each = local.enable_protection ? [true] : []
    content {
      protected_branches     = false
      custom_branch_policies = true
    }
  }
}

resource "github_repository_environment_deployment_policy" "infra" {
  count          = contains(var.envs, "infra") && local.enable_protection ? 1 : 0
  repository     = github_repository.this.name
  environment    = github_repository_environment.infra[0].environment
  branch_pattern = "main"
}


################################################################################
#                                    GitHub                                    #
################################################################################

resource "github_repository_environment" "github" {
  count               = contains(var.envs, "github") ? 1 : 0
  environment         = "github"
  repository          = github_repository.this.name
  prevent_self_review = false

  # We can only include this block in public repos, until we upgrade to GitHub Teams
  dynamic "deployment_branch_policy" {
    for_each = local.enable_protection ? [true] : []
    content {
      # NOTE: protected_branches and custom_branch_policies cannot have the same value
      # https://docs.github.com/en/rest/deployments/environments?apiVersion=2022-11-28#create-or-update-an-environment
      protected_branches     = false
      custom_branch_policies = true
    }
  }
}

resource "github_repository_environment_deployment_policy" "github" {

  count = contains(var.envs, "github") && local.enable_protection ? 1 : 0

  repository     = github_repository.this.name
  environment    = github_repository_environment.github[0].environment
  branch_pattern = "main"
}
