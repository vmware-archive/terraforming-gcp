variable "project" {
  type = "string"
}

variable "env_name" {
  type = "string"
}

variable "region" {
  type    = "string"
  default = "us-central1"
}

/* There is a bug in Google Cloud SQL which takes `us-east1`, `asia-west1`, `europe-west1`
or `us-central`, instead of the `us-central1` used by Google Compute. When the bug is
fixed, we could revert to using the same region for both.
*/
variable "sql_region" {
  type    = "string"
  default = "us-central"
}

variable "zones" {
  default = ["us-central1-a", "us-central1-b", "us-central1-c"]
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

/* You can opt in to create a Google SQL Database Instance, Database, and User.
By default we have `google_sql_instance_count` set to `0` but setting it to `1` will create them. */

variable "google_sql_instance_count" {
  type        = "string"
  default     = "0"
  description = "Optional configuration of a Google SQL Database Instance, Database, and User."
}

variable "google_sql_db_tier" {
  type    = "string"
  default = "db-f1-micro"
}

variable "google_sql_db_host" {
  type    = "string"
  default = ""
}

variable "google_sql_db_username" {
  type    = "string"
  default = ""
}

variable "google_sql_db_password" {
  type    = "string"
  default = ""
}

variable "opsman_storage_bucket_count" {
  type        = "string"
  default     = "0"
  description = "Optional configuration of a Google Storage Bucket for BOSH's blobstore"
}
