# Create Artifact Registry repository
resource "google_artifact_registry_repository" "repo" {
  provider = google
  project  = var.project_id
  location = var.location
  repository_id = var.repository_id
  description = "Docker repository for PetClinic application"
  format = "DOCKER"
}

# IAM policy for the repository
resource "google_artifact_registry_repository_iam_member" "repository_iam" {
  provider   = google
  project    = var.project_id
  location   = google_artifact_registry_repository.repo.location
  repository = google_artifact_registry_repository.repo.repository_id
  role       = "roles/artifactregistry.writer"
  member     = "serviceAccount:${var.project_id}@cloudbuild.gserviceaccount.com"
}


