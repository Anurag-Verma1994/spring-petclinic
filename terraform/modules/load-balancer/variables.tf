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

variable "domain_name" {
  description = "Domain name for the SSL certificate"
  type        = string
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

variable "primary_capacity_scaler" {
  description = "Capacity scaler for primary backend"
  type        = number
  default     = 1.0
}

variable "secondary_capacity_scaler" {
  description = "Capacity scaler for secondary backend"
  type        = number
  default     = 1.0
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

variable "health_check_port" {
  description = "Port for health check"
  type        = number
  default     = 80
}

variable "health_check_path" {
  description = "Path for health check"
  type        = string
  default     = "/actuator/health"
}

variable "ssl_port_range" {
  description = "Port range for HTTPS forwarding rule"
  type        = string
  default     = "443"
}

variable "backend_protocol" {
  description = "Protocol for backend service"
  type        = string
  default     = "HTTPS"
}

variable "backend_port_name" {
  description = "Port name for backend service"
  type        = string
  default     = "http"
}
