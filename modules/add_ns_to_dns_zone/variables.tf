variable "top_level_zone_name" {
  type        = "string"
  description = "Passed in name servers and zone_name will be added to this hosted zone as an NS record"
}

variable "zone_name" {
  type        = "string"
  description = "The root of your zone which will be attached to your NS record"
}

variable "name_servers" {
  type        = "list"
  description = "The nameservers at the root of the hosted zone name provided"
}
