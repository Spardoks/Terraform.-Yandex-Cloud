variable "vm_env" {
  type    = string
  default = "netology-develop-platform"
}

variable "vm_web" {
  type    = string
  default = "web"
}

variable "vm_db" {
  type    = string
  default = "db"
}

locals {
  vm_names = {
    web = "${var.vm_env}-${var.vm_web}"
    db = "${var.vm_env}-${var.vm_db}"
  }
}