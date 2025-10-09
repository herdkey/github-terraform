# noinspection TfUnusedElements tflint-ignore: terraform_unused_declarations
variable "org" {
  type    = string
  default = "savisec"
}

variable "name" {
  type = string
}

variable "description" {
  type = string
}

variable "visibility" {
  type = string
}

variable "homepage_url" {
  type    = string
  default = null
}

variable "topics" {
  type    = list(string)
  default = []
}

locals {
  allowed_envs = ["play", "stage", "prod", "infra", "github"]
}

variable "envs" {
  type        = list(string)
  default     = ["play", "stage", "prod"]
  description = "Environments to enable."
  validation {
    condition     = setintersection(local.allowed_envs, var.envs) == toset(var.envs)
    error_message = "Environment must be one of: play, stage, prod, or infra."
  }
}

variable "prod_reviewers" {
  type        = list(string)
  description = "Usernames of GitHub users who can approve deployments to prod."
}
