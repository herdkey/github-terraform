locals {
  # Private repos cannot use protection rules until we upgrade to GitHub Teams.
  enable_protection = github_repository.this.visibility == "public"
}

data "github_user" "prod_reviewer" {
  for_each = toset(var.prod_reviewers)
  username = each.value
}

# Play
resource "github_repository_environment" "play" {
  count               = contains(var.envs, "play") ? 1 : 0
  environment         = "play"
  repository          = github_repository.this.name
  prevent_self_review = false
  deployment_branch_policy {
    protected_branches     = false
    custom_branch_policies = false
  }
}


# Stage
resource "github_repository_environment" "stage" {
  count               = contains(var.envs, "stage") ? 1 : 0
  environment         = "stage"
  repository          = github_repository.this.name
  prevent_self_review = false
  deployment_branch_policy {
    protected_branches     = true
    custom_branch_policies = true
  }
}

resource "github_repository_environment_deployment_policy" "stage" {

  count = contains(var.envs, "stage") && local.enable_protection ? 1 : 0

  repository     = github_repository.this.name
  environment    = github_repository_environment.stage[0].environment
  branch_pattern = "main"
}


# Prod
resource "github_repository_environment" "prod" {

  count = contains(var.envs, "prod") ? 1 : 0

  environment         = "prod"
  repository          = github_repository.this.name
  prevent_self_review = false
  reviewers {
    users = [for user in data.github_user.prod_reviewer : user.id]
  }
  deployment_branch_policy {
    protected_branches     = true
    custom_branch_policies = true
  }
}

resource "github_repository_environment_deployment_policy" "prod" {
  count          = contains(var.envs, "prod") && local.enable_protection ? 1 : 0
  repository     = github_repository.this.name
  environment    = github_repository_environment.prod[0].environment
  branch_pattern = "main"
}
