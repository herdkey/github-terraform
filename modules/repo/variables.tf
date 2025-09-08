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
