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
    actor_id    = 1     # constant meaning "all org admins"
    bypass_mode = "pull_request"
  }
}

# Protect tags like v1, v1.2.3, etc., and enforce a tag-name pattern
resource "github_repository_ruleset" "version_tags" {

  # API gives 403 until we buy GitHub Teams
  count = 0

  name        = "protect v* tags"
  target      = "tag"
  enforcement = "active"

  conditions {
    ref_name {
      include = ["refs/tags/v*"]
      exclude = []
    }
  }

  rules {
    # Creation allowed; flip to true to forbid creating new v* tags
    creation         = false
    update           = true   # block moving (retagging)
    deletion         = true   # block deleting tags
    non_fast_forward = true

    # loose SemVer (vMAJOR or vMAJOR.MINOR or vMAJOR.MINOR.PATCH)
    tag_name_pattern {
      operator = "regex"
      # v1  or  v1.2  or  v1.2.3
      pattern  = "^v\\d+(?:\\.\\d+){0,2}$"
    }
  }

  bypass_actors {
    actor_type  = "OrganizationAdmin"
    actor_id    = 1     # constant meaning "all org admins"
    bypass_mode = "pull_request"
  }
}
