variable "ports" {
  type = "list"
}

variable "name" {}

variable "protocol" {}

variable "health_check_path" {
  default = ""
}

variable "health_check_port" {
  default = "8080"
}

variable "source_ranges" {
  type = "list"
}

variable "target_tags" {
  type = "list"
}

variable "network" {
  default = ""
}

variable "subnetwork_name" {
  default = ""
}

variable "zones" {
  type = "list"
}

variable "type" {
  default = "EXTERNAL"
}

variable "global_lb" {
  default = false
}
