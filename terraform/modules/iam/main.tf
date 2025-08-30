# Grant necessary permissions to the service account
resource "google_project_iam_member" "service_account_roles" {
  for_each = toset([
    "roles/run.admin",                    # Manage Cloud Run services
    "roles/storage.admin",                # Access to Cloud Storage
    "roles/artifactregistry.admin",       # Access to Artifact Registry
    "roles/cloudbuild.builds.builder",    # Execute Cloud Build jobs
    "roles/iam.serviceAccountUser"        # Use service accounts
  ])

  project = var.project_id
  role    = each.value
  member  = "serviceAccount:${var.service_account_email}"
}
