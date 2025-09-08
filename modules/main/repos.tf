module "hello-go" {
  source      = "../repo"
  name        = "hello-go"
  visibility  = "public"
  description = "Go backend server boilerplate"
}

module "github-terraform" {
  source      = "../repo"
  name        = "github-terraform"
  visibility  = "public"
  description = "Terraform to manage this GitHub organization"
}
