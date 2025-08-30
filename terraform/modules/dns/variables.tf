variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "domain_name" {
  description = "Domain name for DNS configuration"
  type        = string
}

variable "global_lb_ip" {
  description = "IP address of the global load balancer"
  type        = string
}
