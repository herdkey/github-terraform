module "github-terraform" {
  source      = "../repo"
  name        = "github-terraform"
  visibility  = "public"
  description = "Terraform to manage this GitHub organization"
}

module "infra-terraform" {
  source      = "../repo"
  name        = "infra-terraform"
  visibility  = "private"
  description = "Terraform to manage our AWS infrastructure"
}

module "hello-go" {
  source      = "../repo"
  name        = "hello-go"
  visibility  = "public"
  description = "Go backend server boilerplate"
}
