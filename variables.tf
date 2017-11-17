variable "project" {
  type = "string"
}

variable "env_name" {
  type = "string"
}

variable "region" {
  type = "string"
}

variable "management_cidr" {
  type = "string"
  description = "cidr for management subnet"
  default     = "10.0.0.0/24"
}

variable "pas_cidr" {
  type = "string"
  description = "cidr for pas subnet"
  default     = "10.0.4.0/24"
}

variable "services_cidr" {
  type = "string"
  description = "cidr for services subnet"
  default     = "10.0.8.0/24"
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

variable "opsman_machine_type" {
  type    = "string"
  default = "n1-standard-2"
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

variable "ssl_private_key" {
  type        = "string"
  description = "ssl certificate private key content"
}

variable "external_database" {
  description = "standups up a cloud sql database instance for the ops manager and PAS"
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

variable "pas_sql_db_host" {
  type    = "string"
  default = ""
}

variable "opsman_sql_db_host" {
  type    = "string"
  default = ""
}

/*****************************
 * Isolation Segment Options *
 *****************************/

variable "isolation_segment" {
  description = "create the required infrastructure to deploy isolation segment"
  default     = false
}

variable "iso_seg_ssl_cert" {
  type        = "string"
  description = "ssl certificate content"
  default     = ""
}

variable "iso_seg_ssl_private_key" {
  type        = "string"
  description = "ssl certificate private key content"
  default     = ""
}

/********************************
 * Google Cloud Storage Options *
 ********************************/

variable "create_gcs_buckets" {
  description = "create Google Storage Buckets for Elastic Runtime Cloud Controller's file storage"
  default     = true
}
