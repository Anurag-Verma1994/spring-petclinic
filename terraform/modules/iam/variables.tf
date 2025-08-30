variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "service_account_email" {
  description = "Email of the service account to grant permissions to"
  type        = string
}
