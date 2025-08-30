provider "google" {
  project = var.project_id
}

# Enable required APIs
resource "google_project_service" "required_apis" {
  for_each = toset([
    "cloudbuild.googleapis.com",
    "artifactregistry.googleapis.com",
    "dns.googleapis.com",
    "compute.googleapis.com",
    "iam.googleapis.com"
  ])
  
  project = var.project_id
  service = each.value

  disable_dependent_services = true
  disable_on_destroy        = false
}

# Enable compute API for load balancer
resource "google_project_service" "compute_api" {
  project = var.project_id
  service = "compute.googleapis.com"

  disable_dependent_services = true
  disable_on_destroy        = false
}

# Create service account
resource "google_service_account" "petclinic_sa" {
  account_id   = var.service_account_name
  display_name = "PetClinic Service Account"
  project      = var.project_id
}

# Grant Cloud Build Service Account role
resource "google_project_iam_member" "cloudbuild_roles" {
  for_each = toset([
    "roles/cloudbuild.builds.builder",
    "roles/cloudbuild.builds.editor",
    "roles/run.admin",                   # Correct role for Cloud Run administration
    "roles/iam.serviceAccountUser",
    "roles/storage.admin"                # Required for accessing artifacts and build cache
  ])
  
  project = var.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.petclinic_sa.email}"
}

# Primary region Cloud Run service
module "cloud_run_primary" {
  source = "../../modules/cloud-run"

  project_id             = var.project_id
  region                = var.primary_region
  service_name          = "petclinic-${var.environment}-primary"
  image                 = var.image
  min_instances         = var.min_instances
  max_instances         = var.max_instances
  container_concurrency = var.container_concurrency
  service_account_email = google_service_account.petclinic_sa.email

  depends_on = [google_project_service.required_apis]
}

# Secondary region Cloud Run service
module "cloud_run_secondary" {
  source = "../../modules/cloud-run"

  project_id             = var.project_id
  region                = var.secondary_region
  service_name          = "petclinic-${var.environment}-secondary"
  image                 = var.image
  min_instances         = var.min_instances
  max_instances         = var.max_instances
  container_concurrency = var.container_concurrency
  service_account_email = google_service_account.petclinic_sa.email

  depends_on = [google_project_service.required_apis]
}

# Cloud Build configuration
module "cloud_build" {
  source = "../../modules/cloud-build"

  project_id            = var.project_id
  github_owner         = var.github_owner
  github_repo          = var.github_repo
  branch_pattern       = var.branch_pattern
  repository_id        = var.repository_id
  service_account_email = google_service_account.petclinic_sa.email
  location             = var.location

  depends_on = [
    google_project_service.required_apis,
    google_service_account.petclinic_sa,
    google_project_iam_member.cloudbuild_roles
  ]
}

# Load Balancer configuration
module "load_balancer" {
  source = "../../modules/load-balancer"

  project_id              = var.project_id
  name                    = var.lb_name
  primary_service_name    = module.cloud_run_primary.service_name
  primary_service_region  = var.primary_region
  secondary_service_name  = module.cloud_run_secondary.service_name
  secondary_service_region = var.secondary_region
  domain_name            = var.domain_name

  depends_on = [
    module.cloud_run_primary,
    module.cloud_run_secondary,
    google_project_service.compute_api
  ]
}

# DNS configuration
module "dns" {
  source = "../../modules/dns"

  project_id    = var.project_id
  domain_name   = var.domain_name
  global_lb_ip  = module.load_balancer.load_balancer_ip

  depends_on = [
    module.load_balancer
  ]
}
