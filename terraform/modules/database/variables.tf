variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., prod, dev)"
  type        = string
}

variable "region" {
  description = "Primary region for Cloud SQL instance"
  type        = string
}

variable "secondary_region" {
  description = "Secondary region for Cloud SQL failover"
  type        = string
}

variable "database_version" {
  description = "The database version to use"
  type        = string
  default     = "POSTGRES_15"
}

variable "database_name" {
  description = "The name of the database to create"
  type        = string
  default     = "petclinic"
}

variable "database_tier" {
  description = "The machine type to use"
  type        = string
  default     = "db-custom-2-4096"
}
