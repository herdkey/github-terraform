locals {
  main_branch = "main"
}

resource "github_repository" "this" {
  name          = var.name
  description   = var.description
  visibility    = var.visibility
  has_issues    = true
  has_projects  = true
  has_downloads = false
  has_wiki      = true

  # keep remote branch list clean
  delete_branch_on_merge = true

  # only allow squash merges (each PR becomes a single commit on main)
  allow_squash_merge          = true
  squash_merge_commit_title   = "PR_TITLE"
  squash_merge_commit_message = "BLANK"
  allow_merge_commit          = false
  allow_rebase_merge          = false

  # allow setting a PR to auto merge once checks pass and approvals are given
  allow_auto_merge = true

  # don't create an initial commit
  auto_init = false

  homepage_url = var.homepage_url
  topics       = var.topics

  vulnerability_alerts = true
}

output "repository" {
  value = github_repository.this.name
}
