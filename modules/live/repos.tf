locals {
  prod_reviewers = [
    github_membership.michaelknopf.username,
  ]
  platform_topic  = "platform"
  terraform_topic = "terraform"
  renovate_topic  = "renovate"
  hello_topic     = "hello-world"
  go_topic        = "go"
  js_topic        = "js"
}

module "github-terraform" {
  source         = "../repo"
  name           = "github-terraform"
  visibility     = "public"
  description    = "Terraform to manage this GitHub organization"
  envs           = ["play", "stage", "prod", "infra"]
  prod_reviewers = local.prod_reviewers
  topics         = [local.platform_topic, local.terraform_topic]
}

module "infra-terraform" {
  source         = "../repo"
  name           = "infra-terraform"
  visibility     = "private"
  description    = "Terraform to manage our AWS infrastructure"
  envs           = ["play", "stage", "prod", "infra"]
  prod_reviewers = local.prod_reviewers
  topics         = [local.platform_topic, local.terraform_topic]
}

module "renovate-config" {
  source         = "../repo"
  name           = "renovate-config"
  visibility     = "public"
  description    = "Shared renovate configurations"
  prod_reviewers = local.prod_reviewers
  topics         = [local.platform_topic, local.renovate_topic]
}

module "github-actions" {
  source         = "../repo"
  name           = "github-actions"
  visibility     = "public"
  description    = "Shared GitHub Actions"
  prod_reviewers = local.prod_reviewers
  topics         = [local.platform_topic]
}

module "just-common" {
  source         = "../repo"
  name           = "just-common"
  visibility     = "public"
  description    = "Common Justfiles"
  prod_reviewers = local.prod_reviewers
  topics         = [local.platform_topic]
}

module "savi-pytools" {
  source         = "../repo"
  name           = "savi-pytools"
  visibility     = "public"
  description    = "Tools for development"
  prod_reviewers = local.prod_reviewers
  topics         = [local.platform_topic]
}

module "hello-go" {
  source         = "../repo"
  name           = "hello-go"
  visibility     = "public"
  description    = "Go backend server boilerplate"
  prod_reviewers = local.prod_reviewers
  topics         = [local.go_topic, local.hello_topic]
}

module "hello-twilio" {
  source         = "../repo"
  name           = "hello-twilio"
  visibility     = "public"
  description    = "Twilio function POC"
  prod_reviewers = local.prod_reviewers
  topics         = [local.js_topic, local.hello_topic]
}

module "hello-react-native" {
  source         = "../repo"
  name           = "hello-react-native"
  visibility     = "public"
  description    = "React Native POC"
  prod_reviewers = local.prod_reviewers
  topics         = [local.js_topic, local.hello_topic]
}
