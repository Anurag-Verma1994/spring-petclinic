# IAM configuration
module "iam" {
  source = "../../modules/iam"

  project_id                  = var.project_id
  service_account_name        = var.service_account_name
  service_account_roles       = var.service_account_roles
  required_apis              = var.required_apis
  disable_dependent_services = var.disable_dependent_services
  disable_on_destroy         = var.disable_on_destroy
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
  service_account_email = module.iam.service_account_email
  environment           = var.environment
  
  # Resource limits
  cpu_limit             = var.cpu_limit
  memory_limit          = var.memory_limit
  
  # Startup probe configuration
  startup_probe_initial_delay     = var.startup_probe_initial_delay
  startup_probe_timeout          = var.startup_probe_timeout
  startup_probe_period           = var.startup_probe_period
  startup_probe_failure_threshold = var.startup_probe_failure_threshold
  startup_probe_path             = var.startup_probe_path

  depends_on = [module.iam]
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
  service_account_email = module.iam.service_account_email
  environment           = var.environment
  
  # Resource limits
  cpu_limit             = var.cpu_limit
  memory_limit          = var.memory_limit
  
  # Startup probe configuration
  startup_probe_initial_delay     = var.startup_probe_initial_delay
  startup_probe_timeout          = var.startup_probe_timeout
  startup_probe_period           = var.startup_probe_period
  startup_probe_failure_threshold = var.startup_probe_failure_threshold
  startup_probe_path             = var.startup_probe_path

  depends_on = [module.iam]
}

# Cloud Build configuration
module "cloud_build" {
  source = "../../modules/cloud-build"

  project_id            = var.project_id
  github_owner          = var.github_owner
  github_repo           = var.github_repo
  branch_pattern        = var.branch_pattern
  repository_id         = var.repository_id
  service_account_email = module.iam.service_account_email
  location              = var.location
  environment           = var.environment

  depends_on = [
    module.iam
  ]
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
  
  # Load balancer configuration
  backend_timeout_sec         = var.backend_timeout_sec
  enable_cdn                  = var.enable_cdn
  health_check_timeout_sec    = var.health_check_timeout_sec
  health_check_interval_sec   = var.health_check_interval_sec
  health_check_path          = var.startup_probe_path

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

