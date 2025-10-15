resource "github_membership" "michaelknopf" {
  username = "michaelknopf"
  role     = "admin"
}

resource "github_membership" "ryan_coughlin" {
  username = "coughlinslaws"
  role     = "member"
}

output "michaelknopf" {
  value = github_membership.michaelknopf.id
}

output "ryan_coughlin" {
  value = github_membership.ryan_coughlin.id
}
