# Organization-level settings.
# GitHub provider exposes some org settings via resources and data.
# Many org settings are limited; we at least manage default repository settings via github_organization_settings.
resource "github_organization_settings" "this" {
  name    = var.org
  company = "Savi Security"
  email   = var.admin_email

  default_repository_permission           = "read"
  members_can_create_public_repositories  = true
  members_can_create_private_repositories = true
  members_can_create_pages                = true
  members_can_create_public_pages         = true
  members_can_create_private_pages        = true
  members_can_fork_private_repositories   = false # default value, but forking creates clutter
  billing_email                           = var.admin_email
}

output "organization_id" {
  value = github_organization_settings.this.id
}

output "organization_name" {
  value = github_organization_settings.this.name
}
