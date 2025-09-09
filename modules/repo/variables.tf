# noinspection TfUnusedElements tflint-ignore: terraform_unused_declarations
variable "org" {
  type    = string
  default = "herdkey"
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

variable "envs" {
  type        = list(string)
  default     = ["play", "stage", "prod"]
  description = "Environments to enable."
  validation {
    condition     = length(setintersection(["play", "stage", "prod", "infra"], var.envs)) > 0
    error_message = "Environment must be one of: play, stage, prod, or infra."
  }
}

variable "prod_reviewers" {
  type        = list(string)
  description = "Usernames of GitHub users who can approve deployments to prod."
}
