# Root Terragrunt configuration
# Centralizes remote state for all environments and common settings.

locals {
  state_region     = "us-west-2"
  state_bucket     = "savi-github-tf-state"
  lock_table       = "savi-github-tf-locks"
  infra_account_id = "073835883885"
  tf_backend_role  = get_env("TG_BACKEND_ROLE", "apply")
}

# Configure remote state for all child Terragrunt configs via include
remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket         = local.state_bucket
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = local.state_region
    dynamodb_table = local.lock_table
    use_lockfile   = true
    encrypt        = true
    assume_role = {
      role_arn = "arn:aws:iam::${local.infra_account_id}:role/github-tf-backend-${local.tf_backend_role}"
    }
  }
}

generate "versions" {
  path      = "versions.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<-EOF
    terraform {
      # latest OpenTofu version
      required_version = ">= 1.10.6"

      required_providers {
        github = {
          source  = "integrations/github",
          version = "~> 6.0"
        }
        tls  = {
          source = "hashicorp/tls",
          version = ">= 4.1.0"
        }
      }
    }
  EOF
}

generate "provider" {
  path      = "provider.aws.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
    provider "aws" {
      region = "$${var.aws_region}"
      # guardrail to prevent accidentally running in wrong account
      allowed_account_ids = [var.aws_account_id]
      default_tags {
        tags = {
          Environment = "$${var.env}"
          ManagedBy   = "Terraform"
        }
      }
    }
  EOF
}

# Configure common Terraform CLI arguments (this is a common pattern)
terraform {
  extra_arguments "common" {
    # Which Terraform commands this applies to:
    commands = get_terraform_commands_that_need_vars()
    # Extra flags to always pass when running those commands:
    arguments = [
      # If lock is unavailable, don't fail immediately. Wait up to 20 minutes to acquire.
      "-lock-timeout=20m",
      "-input=false",
    ]
  }
}

# You can declare common inputs here to pass into modules (optional)
inputs = {
  aws_region        = local.aws_region
  state_bucket_name = local.state_bucket
  lock_table_name   = local.lock_table
  infra_account_id  = local.infra_account_id
}
