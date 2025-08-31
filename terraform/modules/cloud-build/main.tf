# Application deployment trigger (for Java code changes)
resource "google_cloudbuild_trigger" "app_trigger" {
  name        = "petclinic-app-trigger"
  description = "Build and deploy PetClinic application when Java code changes"
  project     = var.project_id
  location    = var.location
  filename    = "cloudbuild.yaml"
  disabled    = false

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

  service_account = "projects/${var.project_id}/serviceAccounts/${var.service_account_email}"

  approval_config {
    approval_required = false
  }

  github {
    name  = var.github_repo
    owner = var.github_owner
    push {
      branch       = "^${var.branch_pattern}$"
      invert_regex = false
    }
  }
}

# Infrastructure deployment triggers for each environment
resource "google_cloudbuild_trigger" "infrastructure_triggers" {
  for_each = {
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

  name        = "petclinic-terraform-${each.key}-trigger"
  description = "Deploy infrastructure for ${each.key} environment when Terraform files change"
  project     = var.project_id
  location    = var.location
  filename    = "cloudbuild-terraform.yaml"
  disabled    = false

  included_files = [
    "terraform/**",
    "*.tf",
    "cloudbuild-terraform.yaml"
  ]

  ignored_files = [
    "src/**",
    "pom.xml",
    "Dockerfile",
    "cloudbuild.yaml"
  ]

  service_account = "projects/${var.project_id}/serviceAccounts/${var.service_account_email}"

  substitutions = {
    "_ENVIRONMENT" = each.key
  }

  approval_config {
    approval_required = each.value.approval_required
  }

  github {
    name  = var.github_repo
    owner = var.github_owner
    push {
      branch       = "^${each.value.branch}$"
      invert_regex = false
    }
  }
}
