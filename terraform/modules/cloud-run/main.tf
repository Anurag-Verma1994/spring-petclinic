resource "google_cloud_run_service" "service" {
  name     = var.service_name
  location = var.region
  project  = var.project_id

  template {
    spec {
      service_account_name = var.service_account_email
      containers {
        image = var.image
        resources {
          limits = {
            cpu    = var.cpu_limit
            memory = var.memory_limit
          }
        }

        startup_probe {
          initial_delay_seconds = var.startup_probe_initial_delay
          timeout_seconds      = var.startup_probe_timeout
          period_seconds      = var.startup_probe_period
          failure_threshold   = var.startup_probe_failure_threshold
          http_get {
            path = var.startup_probe_path
          }
        }
      }
      container_concurrency = var.container_concurrency
    }

    metadata {
      annotations = {
        "autoscaling.knative.dev/minScale"        = var.min_instances
        "autoscaling.knative.dev/maxScale"        = var.max_instances
        "run.googleapis.com/cpu-throttling"       = "false"  # CPU always allocated
        "run.googleapis.com/startup-cpu-boost"    = "true"   # CPU boost during startup
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

  autogenerate_revision_name = true
}

output "service_url" {
  value = google_cloud_run_service.service.status[0].url
}

# IAM policy to make the service public
resource "google_cloud_run_service_iam_member" "public" {
  location = google_cloud_run_service.service.location
  project  = var.project_id
  service  = google_cloud_run_service.service.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}

