project_id = "assessment-vermaanurag1794"
primary_region = "europe-west4"
secondary_region = "europe-west3"
environment = "prod"
domain_name = "gorillaclinic.nl"
min_instances = 1
max_instances = 400
container_concurrency = 80
service_account_name = "petclinic-sa"

# Service account IAM roles
service_account_roles = [
  "roles/cloudbuild.builds.builder",
  "roles/cloudbuild.builds.editor", 
  "roles/run.admin",
  "roles/iam.serviceAccountUser",
  "roles/compute.admin",
  "roles/iam.serviceAccountAdmin",
  "roles/serviceusage.serviceUsageAdmin",
  "roles/storage.admin"
]

# Google Cloud APIs to enable
required_apis = [
  "cloudresourcemanager.googleapis.com",
  "cloudbuild.googleapis.com",
  "artifactregistry.googleapis.com",
  "dns.googleapis.com",
  "compute.googleapis.com",
  "iam.googleapis.com",
  "sqladmin.googleapis.com",
  "secretmanager.googleapis.com",
  "run.googleapis.com"  # Added Cloud Run API
]

# API management settings
disable_dependent_services = true
disable_on_destroy = false

github_owner = "Anurag-Verma1994"
github_repo = "spring-petclinic"
branch_pattern = "main"
location = "europe-west4"
repository_id = "petclinic"
lb_name = "petclinic-prod"
image = "gcr.io/assessment-vermaanurag1794/petclinic:latest"
primary_service_name = "petclinic-prod-primary"
secondary_service_name = "petclinic-prod-secondary"

# Resource configuration
cpu_limit = "4.0"
memory_limit = "4Gi"

# Startup probe configuration
startup_probe_initial_delay = 30
startup_probe_timeout = 10
startup_probe_period = 10
startup_probe_failure_threshold = 6
startup_probe_path = "/actuator/health"

# Load balancer configuration
backend_timeout_sec = 30
enable_cdn = true
health_check_timeout_sec = 5
health_check_interval_sec = 10

