variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "primary_region" {
  description = "Primary region for deployment"
  type        = string
}

variable "secondary_region" {
  description = "Secondary region for deployment"
  type        = string
}

variable "environment" {
  description = "Environment (prod, dev, staging)"
  type        = string
}

variable "domain_name" {
  description = "Domain name for the application"
  type        = string
}

variable "min_instances" {
  description = "Minimum number of instances"
  type        = number
}

variable "max_instances" {
  description = "Maximum number of instances"
  type        = number
}

variable "container_concurrency" {
  description = "Maximum concurrent requests per container"
  type        = number
}

variable "service_account_name" {
  description = "Name of the service account"
  type        = string
}

variable "image" {
  description = "Container image to deploy"
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
  description = "Branch pattern to trigger builds"
  type        = string
}

variable "location" {
  description = "Location for Artifact Registry"
  type        = string
}

variable "repository_id" {
  description = "ID for Artifact Registry repository"
  type        = string
}

variable "lb_name" {
  description = "Name for the load balancer"
  type        = string
}

variable "primary_service_name" {
  description = "Name for the primary Cloud Run service"
  type        = string
}

variable "secondary_service_name" {
  description = "Name for the secondary Cloud Run service"
  type        = string
}


