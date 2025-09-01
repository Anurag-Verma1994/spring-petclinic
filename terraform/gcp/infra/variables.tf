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

variable "cpu_limit" {
  description = "CPU limit for the container"
  type        = string
  default     = "4.0"
}

variable "memory_limit" {
  description = "Memory limit for the container"
  type        = string
  default     = "4Gi"
}

variable "startup_probe_initial_delay" {
  description = "Initial delay seconds for startup probe"
  type        = number
  default     = 30
}

variable "startup_probe_timeout" {
  description = "Timeout seconds for startup probe"
  type        = number
  default     = 10
}

variable "startup_probe_period" {
  description = "Period seconds for startup probe"
  type        = number
  default     = 10
}

variable "startup_probe_failure_threshold" {
  description = "Failure threshold for startup probe"
  type        = number
  default     = 6
}

variable "startup_probe_path" {
  description = "Health check path for startup probe"
  type        = string
  default     = "/actuator/health"
}

variable "backend_timeout_sec" {
  description = "Backend service timeout in seconds"
  type        = number
  default     = 30
}

variable "enable_cdn" {
  description = "Enable CDN for the backend service"
  type        = bool
  default     = true
}

variable "health_check_timeout_sec" {
  description = "Health check timeout in seconds"
  type        = number
  default     = 5
}

variable "health_check_interval_sec" {
  description = "Health check interval in seconds"
  type        = number
  default     = 10
}


