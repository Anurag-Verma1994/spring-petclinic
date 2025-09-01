variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The region to deploy the Cloud Run service"
  type        = string
}

variable "service_name" {
  description = "Name of the Cloud Run service"
  type        = string
}

variable "image" {
  description = "Docker image to deploy"
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
  description = "Maximum number of concurrent requests per container"
  type        = number
}

variable "service_account_email" {
  description = "Service account email for the Cloud Run service"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., prod, dev)"
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
