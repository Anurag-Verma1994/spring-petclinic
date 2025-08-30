variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "name" {
  description = "Base name for load balancer resources"
  type        = string
}

variable "primary_service_name" {
  description = "Name of the primary Cloud Run service"
  type        = string
}

variable "primary_service_region" {
  description = "Region of the primary Cloud Run service"
  type        = string
}

variable "secondary_service_name" {
  description = "Name of the secondary Cloud Run service"
  type        = string
}

variable "secondary_service_region" {
  description = "Region of the secondary Cloud Run service"
  type        = string
}
