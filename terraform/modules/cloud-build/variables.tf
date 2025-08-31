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

variable "environment_branch_mappings" {
  description = "Map of environments to their corresponding branch and approval configurations"
  type = map(object({
    branch = string
    approval_required = bool
  }))
  default = {
    prod = {
      branch = "main"
      approval_required = false
    }
    staging = {
      branch = "staging"
      approval_required = false
    }
    test = {
      branch = "test"
      approval_required = false
    }
  }
}

