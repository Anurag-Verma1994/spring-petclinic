# Application deployment trigger (for Java code changes)
resource "google_cloudbuild_trigger" "app_trigger" {
  name        = "petclinic-app-trigger"
  description = "Build and deploy PetClinic application when Java code changes"
  project     = var.project_id
  location    = var.location
  
  # Specify the path to the Cloud Build configuration file.
  filename = "cloudbuild.yaml"

  github {
    owner = var.github_owner
    name  = var.github_repo
    push {
      branch = var.branch_pattern
    }
  }

  included_files = [
    "src/**",
    "pom.xml",
    "Dockerfile",
    "cloudbuild.yaml"
  ]

  ignored_files = [
    "terraform/**",
    "*.tf"
  ]

  service_account = var.service_account_email
}

# Infrastructure deployment trigger (for Terraform changes)
resource "google_cloudbuild_trigger" "infrastructure_trigger" {
  name        = "petclinic-terraform-trigger"
  description = "Deploy infrastructure when Terraform files change"
  project     = var.project_id
  location    = var.location
  
  # Specify the path to the Cloud Build configuration file.
  filename = "cloudbuild-terraform.yaml"

  github {
    owner = var.github_owner
    name  = var.github_repo
    push {
      branch = var.branch_pattern
    }
  }

  included_files = [
    "terraform/**",
    "*.tf"
  ]

  substitutions = {
    _ENVIRONMENT = "prod"
  }
  service_account = var.service_account_email
}


# Outputs
output "app_trigger_id" {
  value       = google_cloudbuild_trigger.app_trigger.id
  description = "The ID of the application deployment trigger"
}

output "infrastructure_trigger_id" {
  value       = google_cloudbuild_trigger.infrastructure_trigger.id
  description = "The ID of the infrastructure deployment trigger"
}