locals {
  super_admins = [
    "michaelknopf"
  ]
}

# Protect main branch by default
resource "github_branch_protection" "main" {

  repository_id = github_repository.this.node_id
  pattern       = local.main_branch

  # require status checks even for repo admins
  enforce_admins = true

  required_status_checks {
    # Doesn't need to necessarily run against latest commit of main.
    # That would require to much syncing from main and a lot of workflow runs.
    strict   = false
    contexts = ["*"]
  }

  required_pull_request_reviews {
    required_approving_review_count = 1
    # don't dismiss approvals after a new push (helps us move faster)
    dismiss_stale_reviews           = false
    # allow people to dismiss a blocking review that requested changes
    restrict_dismissals             = false
    require_code_owner_reviews      = false
    pull_request_bypassers = [
      for user in local.super_admins :
      "/${user}"
    ]
  }

  restrict_pushes {
    # Allow someone to create the main branch (for bootstrapping the repo)
    blocks_creations = false
  }

  # Disallow force pushes and deletions explicitly
  # (these are defaults when PRs are required anyway)
  allows_deletions    = false
  allows_force_pushes = false

  require_signed_commits = false
}
