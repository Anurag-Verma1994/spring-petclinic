# Get database connection info from Secret Manager
data "google_secret_manager_secret_version" "db_connection" {
  project = var.project_id
  secret  = "petclinic-${var.environment}-db-connection"
  version = "latest"
}

data "google_secret_manager_secret_version" "db_password" {
  project = var.project_id
  secret  = "petclinic-${var.environment}-db-password"
  version = "latest"
}

locals {
  db_connection = jsondecode(data.google_secret_manager_secret_version.db_connection.secret_data)
}

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
            cpu    = "4.0"
            memory = "4Gi"
          }
        }

        env {
          name = "SPRING_PROFILES_ACTIVE"
          value = "postgres"
        }

        env {
          name  = "POSTGRES_HOST"
          value = local.db_connection.host
        }
        
        env {
          name  = "POSTGRES_PORT"
          value = tostring(local.db_connection.port)
        }

        env {
          name  = "POSTGRES_DB"
          value = local.db_connection.database
        }

        env {
          name  = "POSTGRES_USER"
          value = local.db_connection.username
        }

        env {
          name  = "POSTGRES_PASS"
          value_from {
            secret_key_ref {
              name = "petclinic-${var.environment}-db-password"
              key  = "latest"
            }
          }
        }

        startup_probe {
          initial_delay_seconds = 30
          timeout_seconds      = 10
          period_seconds      = 10
          failure_threshold   = 6
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
        "run.googleapis.com/cloudsql-instances"   = "${var.project_id}:europe-west4:petclinic-${var.environment}-primary"
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

