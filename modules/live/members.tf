resource "github_membership" "michaelknopf" {
  username = "michaelknopf"
  role     = "admin"
}

output "michaelknopf" {
  value = github_membership.michaelknopf.id
}
