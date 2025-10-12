variable "admin_email" {
  type    = string
  default = "admin+github@savisecurity.com"
}

variable "infra_account_id" {
  type        = string
  description = "AWS account ID for infrastructure"
}
