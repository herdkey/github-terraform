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
  allowed_envs = [
    # Live environments
    "play",
    "stage",
    "prod",
    # For workflows that make changes to the infra account
    "infra",
    # For workflows that modify GitHub things in GitHub
    "github",
    # Publish releases to the "release" tier in ECR or CodeArtifact
    "release",
  ]
  envs_error_msg = "Environment must be one of: ${join(", ", local.allowed_envs)}"
}

variable "envs" {
  type        = list(string)
  default     = ["release", "play", "stage", "prod"]
  description = "Environments to enable."
  validation {
    condition     = setintersection(local.allowed_envs, var.envs) == toset(var.envs)
    error_message = local.envs_error_msg
  }
}

variable "prod_reviewers" {
  type        = list(string)
  description = "Usernames of GitHub users who can approve deployments to prod."
}
