variable "project" {
  type = "string"
}

variable "env_name" {
  type = "string"
}

variable "region" {
  type = "string"
}

variable "zones" {
  type = "list"
}

variable "opsman_image_name" {
  type = "string"
}

variable "service_account_key" {
  type = "string"
}

variable "dns_suffix" {
  type = "string"
}

variable "ssl_cert" {
  type        = "string"
  description = "ssl certificate content"
}

variable "ssl_cert_private_key" {
  type        = "string"
  description = "ssl certificate private key content"
}

variable "sql_db_tier" {
  type    = "string"
  default = "db-f1-micro"
}

/******************
 * OpsMan Options *
 ******************/

/* You can opt in to create a Google SQL Database Instance, Database, and User for OpsMan.
By default we have `opsman_sql_instance_count` set to `0` but setting it to `1` will create them. */

variable "opsman_sql_instance_count" {
  type        = "string"
  default     = "0"
  description = "Optional configuration of a Google SQL Database Instance, Database, and User."
}

variable "opsman_sql_db_host" {
  type    = "string"
  default = ""
}

variable "opsman_sql_db_username" {
  type    = "string"
  default = ""
}

variable "opsman_sql_db_password" {
  type    = "string"
  default = ""
}

variable "opsman_storage_bucket_count" {
  type        = "string"
  default     = "0"
  description = "Optional configuration of a Google Storage Bucket for BOSH's blobstore"
}
