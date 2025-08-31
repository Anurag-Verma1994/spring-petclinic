# Create primary Cloud SQL instance
resource "google_sql_database_instance" "primary" {
  name                = "petclinic-${var.environment}-primary"
  database_version    = var.database_version
  region             = var.region
  project            = var.project_id
  deletion_protection = true

  settings {
    tier              = var.database_tier
    availability_type = "REGIONAL"  # HA within primary region
    
    backup_configuration {
      enabled                        = true
      point_in_time_recovery_enabled = true
      location                       = var.secondary_region
      backup_retention_settings {
        retained_backups = 7
        retention_unit   = "COUNT"
      }
    }

    ip_configuration {
      ipv4_enabled    = true
    }

    maintenance_window {
      day          = 7  # Sunday
      hour         = 3  # 3 AM
      update_track = "stable"
    }
  }
}

# Create read replica in secondary region
resource "google_sql_database_instance" "secondary" {
  name                 = "petclinic-${var.environment}-secondary"
  database_version     = var.database_version
  region              = var.secondary_region
  project             = var.project_id
  deletion_protection = true
  master_instance_name = google_sql_database_instance.primary.name

  settings {
    tier              = var.database_tier
    availability_type = "REGIONAL"  # HA within secondary region

    ip_configuration {
      ipv4_enabled    = true
    }

    maintenance_window {
      day          = 6  # Saturday
      hour         = 3  # 3 AM
      update_track = "stable"
    }
  }

  depends_on = [google_sql_database_instance.primary]
}

# Create database on primary instance
resource "google_sql_database" "database" {
  name     = var.database_name
  instance = google_sql_database_instance.primary.name
  project  = var.project_id
}

# Create user on primary instance using secrets
resource "google_sql_user" "petclinic" {
  name     = data.google_secret_manager_secret_version.db_username.secret_data
  instance = google_sql_database_instance.primary.name
  password = data.google_secret_manager_secret_version.db_password.secret_data
  project  = var.project_id
}

# Get database credentials from Secret Manager
data "google_secret_manager_secret_version" "db_username" {
  project = var.project_id
  secret  = "petclinic-${var.environment}-db-username"
  version = "latest"
}

data "google_secret_manager_secret_version" "db_password" {
  project = var.project_id
  secret  = "petclinic-${var.environment}-db-password"
  version = "latest"
}

# Access the existing connection information secret
data "google_secret_manager_secret_version" "db_connection" {
  project = var.project_id
  secret  = "petclinic-${var.environment}-db-connection"
  version = "latest"
}
