variable "project" {
  type = "string"
}

variable "env_name" {
  type        = "string"
  description = "Used for creating service accounts. No longer than 5 characters, a-z only."
}

variable "region" {
  type = "string"
}

variable "zones" {
  type = "list"
}

variable "opsman_image_url" {
  type        = "string"
  description = "location of ops manager image on google cloud storage"
}

variable "optional_opsman_image_url" {
  type        = "string"
  description = "location of ops manager image (to be used for optional extra instance) on google cloud storage"
  default     = ""
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

/***********************
 * Optional ERT Config *
 ***********************/

/* You can opt in to create a Google SQL Database Instance, Database, and User for ERT.
By default we have `ert_sql_instance_count` set to `0` but setting it to `1` will create them. */

variable "ert_sql_instance_count" {
  type        = "string"
  default     = "0"
  description = "Optional configuration of a Google SQL Database Instance, Database, and User."
}

variable "ert_sql_db_host" {
  type    = "string"
  default = ""
}

variable "ert_sql_db_username" {
  type    = "string"
  default = ""
}

variable "ert_sql_db_password" {
  type    = "string"
  default = ""
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
