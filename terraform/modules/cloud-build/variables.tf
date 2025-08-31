variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "github_owner" {
  description = "GitHub repository owner"
  type        = string
}

variable "github_repo" {
  description = "GitHub repository name"
  type        = string
}

variable "branch_pattern" {
  description = "Branch pattern to trigger the build"
  type        = string
}

variable "repository_id" {
  description = "The ID of the Cloud Source Repository"
  type        = string
  default     = "petclinic"
}

variable "service_account_email" {
  description = "Service account email for Cloud Build"
  type        = string
}

variable "location" {
  description = "The location for Cloud Build resources"
  type        = string
  default     = "europe-west4"
}


variable "environment" {
  description = "The environment for the deployment"
  type        = string
}
