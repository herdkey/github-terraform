# This mirrors our branch protection rules.
# But we can't use Rulesets until we buy GitHub Teams.
# So this is disabled (see count=0 below).
resource "github_repository_ruleset" "main" {

  # API gives 403 until we buy GitHub Teams
  count = 0

  name        = "main"
  target      = "branch"
  enforcement = "active"

  conditions {
    ref_name {
      include = ["main"]
      exclude = []
    }
  }

  rules {
    # Match your intent:
    creation                = false # don't restrict creating the branch
    update                  = false # don't lock the branch
    deletion                = true  # block deletions
    non_fast_forward        = true  # block force-pushes
    required_linear_history = false
    required_signatures     = false

    # Require a PR + reviews
    pull_request {
      required_approving_review_count   = 1
      dismiss_stale_reviews_on_push     = false
      require_code_owner_review         = false
      require_last_push_approval        = false
      required_review_thread_resolution = false
    }

  }

  bypass_actors {
    actor_type  = "OrganizationAdmin"
    actor_id    = 1
    bypass_mode = "pull_request"
  }
}
