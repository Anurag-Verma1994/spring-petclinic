variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "location" {
  description = "Location for the Artifact Registry repository"
  type        = string
}

variable "repository_id" {
  description = "ID of the repository"
  type        = string
  default     = "petclinic"
}
