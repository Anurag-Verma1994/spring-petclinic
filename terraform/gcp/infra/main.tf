provider "google" {
  project = var.project_id
  region  = var.primary_region
}

# Enable required APIs
resource "google_project_service" "required_apis" {
  for_each = toset([
    "cloudresourcemanager.googleapis.com",
    "cloudbuild.googleapis.com",
    "artifactregistry.googleapis.com",
    "dns.googleapis.com",
    "compute.googleapis.com",
    "iam.googleapis.com",
    "sqladmin.googleapis.com",
    "secretmanager.googleapis.com"
  ])

  project = var.project_id
  service = each.value

  disable_dependent_services = true
  disable_on_destroy         = false
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
    "roles/run.admin",
    "roles/iam.serviceAccountUser",
    "roles/compute.admin",
    "roles/iam.serviceAccountAdmin",
    "roles/serviceusage.serviceUsageAdmin",
    "roles/storage.admin",
    "roles/secretmanager.secretAccessor",
    "roles/secretmanager.admin",
    "roles/cloudsql.admin",
    "roles/resourcemanager.projectIamAdmin"
  ])

  project = var.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.petclinic_sa.email}"
}


# Primary region Cloud Run service
module "cloud_run_primary" {
  source = "../../modules/cloud-run"

  project_id            = var.project_id
  region                = var.primary_region
  service_name          = "petclinic-${var.environment}-primary"
  image                 = var.image
  min_instances         = var.min_instances
  max_instances         = var.max_instances
  container_concurrency = var.container_concurrency
  service_account_email = google_service_account.petclinic_sa.email
  environment           = var.environment

  depends_on = [google_project_service.required_apis]
}

# Secondary region Cloud Run service
module "cloud_run_secondary" {
  source = "../../modules/cloud-run"

  project_id            = var.project_id
  region                = var.secondary_region
  service_name          = "petclinic-${var.environment}-secondary"
  image                 = var.image
  min_instances         = var.min_instances
  max_instances         = var.max_instances
  container_concurrency = var.container_concurrency
  service_account_email = google_service_account.petclinic_sa.email
  environment           = var.environment

  depends_on = [google_project_service.required_apis]
}

# Cloud Build configuration
module "cloud_build" {
  source = "../../modules/cloud-build"

  project_id            = var.project_id
  github_owner          = var.github_owner
  github_repo           = var.github_repo
  branch_pattern        = var.branch_pattern
  repository_id         = var.repository_id
  service_account_email = google_service_account.petclinic_sa.email
  location              = var.location
  environment           = var.environment

  depends_on = [
    google_project_service.required_apis,
    google_service_account.petclinic_sa,
    google_project_iam_member.cloudbuild_roles
  ]
}

# Database configuration
module "database" {
  source = "../../modules/database"

  project_id       = var.project_id
  environment      = var.environment
  region          = var.primary_region
  secondary_region = var.secondary_region

  depends_on = [google_project_service.required_apis]
}

# Load Balancer configuration
module "load_balancer" {
  source = "../../modules/load-balancer"

  project_id               = var.project_id
  name                     = var.lb_name
  primary_service_name     = module.cloud_run_primary.service_name
  primary_service_region   = var.primary_region
  secondary_service_name   = module.cloud_run_secondary.service_name
  secondary_service_region = var.secondary_region
  domain_name              = var.domain_name

  depends_on = [
    module.cloud_run_primary,
    module.cloud_run_secondary
  ]
}

# DNS configuration
module "dns" {
  source = "../../modules/dns"

  project_id   = var.project_id
  domain_name  = var.domain_name
  global_lb_ip = module.load_balancer.load_balancer_ip

  depends_on = [
    module.load_balancer
  ]
}
