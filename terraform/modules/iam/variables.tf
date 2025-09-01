variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "service_account_name" {
  description = "Name/ID of the service account to create"
  type        = string
}

variable "service_account_display_name" {
  description = "Display name of the service account"
  type        = string
  default     = "PetClinic Service Account"
}

variable "service_account_roles" {
  description = "List of IAM roles to grant to the service account"
  type        = list(string)
  default = [
    "roles/cloudbuild.builds.builder",
    "roles/cloudbuild.builds.editor",
    "roles/run.admin",
    "roles/iam.serviceAccountUser",
    "roles/compute.admin",
    "roles/iam.serviceAccountAdmin",
    "roles/serviceusage.serviceUsageAdmin",
    "roles/storage.admin"
  ]
}

variable "required_apis" {
  description = "List of Google Cloud APIs to enable"
  type        = list(string)
  default = [
    "cloudresourcemanager.googleapis.com",
    "cloudbuild.googleapis.com",
    "artifactregistry.googleapis.com",
    "dns.googleapis.com",
    "compute.googleapis.com",
    "iam.googleapis.com",
    "sqladmin.googleapis.com",
    "secretmanager.googleapis.com"
  ]
}

variable "disable_dependent_services" {
  description = "Whether to disable dependent services when destroying"
  type        = bool
  default     = true
}

variable "disable_on_destroy" {
  description = "Whether to disable services when destroying"
  type        = bool
  default     = false
}
