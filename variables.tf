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

variable "external_database" {
  description = "standups up a cloud sql database instance for the ops manager and ERT"
  default     = false
}

/******************
 * OpsMan Options *
 ******************/

variable "opsman_storage_bucket_count" {
  type        = "string"
  default     = "0"
  description = "Optional configuration of a Google Storage Bucket for BOSH's blobstore"
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

/*****************************
 * Isolation Segment Options *
 *****************************/

variable "isoseg_ssl_cert" {
  type        = "string"
  description = "ssl certificate content"
  default     = ""
}

variable "isoseg_ssl_cert_private_key" {
  type        = "string"
  description = "ssl certificate private key content"
  default     = ""
}

variable "create_isoseg_resources" {
  type        = "string"
  default     = "0"
  description = "Optionally create a LB and DNS entries for a single isolation segment. Valid values are 0 or 1."
}
