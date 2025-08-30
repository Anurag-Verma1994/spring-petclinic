resource "google_cloud_run_service" "service" {
  name     = var.service_name
  location = var.region

  template {
    spec {
      service_account_name = var.service_account_email
      containers {
        image = var.image
        resources {
          limits = {
            cpu    = "4.0"
            memory = "4Gi"
          }
        }
        startup_probe {
          initial_delay_seconds = 10
          timeout_seconds      = 3
          period_seconds      = 5
          failure_threshold   = 3
          http_get {
            path = "/actuator/health"
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
