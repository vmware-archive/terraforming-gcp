variable "project" {
  type = "string"
}

variable "env_name" {
  type = "string"
}

variable "region" {
  type = "string"
}

variable "infrastructure_cidr" {
  type        = "string"
  description = "cidr for infrastructure subnet"
  default     = "10.0.0.0/26"
}

variable "zones" {
  type = "list"
}

variable "opsman_image" {
  type        = "string"
  description = "Name of public ops manager image in pivotal-ops-manager-images project"
}

variable "optional_opsman_image" {
  type        = "string"
  description = "Name of public ops manager image in pivotal-ops-manager-images project (to be used for optional extra instance)"
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
  type        = "string"
  description = "Domain to add environment subdomain to (e.g. foo.example.com). Trailing dots are not supported."
}

variable "create_iam_service_account_members" {
  description = "If set to true, create an IAM Service Account project roles"
  default     = true
}

variable "external_database" {
  description = "standups up a cloud sql database instance for the Ops Manager"
  default     = false
}

variable "internetless" {
  description = "When set to true, all traffic going outside the 10.* network is denied."
  default     = false
}

///******************
// * OpsMan Options *
// ******************/

variable "opsman_storage_bucket_count" {
  type        = "string"
  description = "Optional configuration of a Google Storage Bucket for BOSH's blobstore"
  default     = "0"
}

variable "opsman_sql_db_host" {
  type        = "string"
  description = "The host the user can connect from."
  default     = ""
}

/*****************************
 * PKS Options *
 *****************************/

variable "pks_cidr" {
  type        = "string"
  description = "cidr for pks subnet"
  default     = "10.0.10.0/24"
}

variable "pks_services_cidr" {
  type        = "string"
  description = "cidr for pks services subnet"
  default     = "10.0.11.0/24"
}

variable "enable_gcr" {
  description = "permits worker nodes to access gcr.io"
  default     = false
}

///********************************
// * Google Cloud Storage Options *
// ********************************/

variable "create_blobstore_service_account_key" {
  description = "Create a scoped service account key for gcs storage access"
  default     = true
}

/*****************************
 * Certificates *
 *****************************/

variable "ssl_cert" {
  type        = "string"
  description = "The contents of an SSL certificate to be used by the LB, optional if `ssl_ca_cert` is provided"
  default     = ""
}

variable "ssl_private_key" {
  type        = "string"
  description = "The contents of an SSL private key to be used by the LB, optional if `ssl_ca_cert` is provided"
  default     = ""
}
