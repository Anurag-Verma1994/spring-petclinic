# Enable required APIs FIRST - this must happen before anything else
resource "google_project_service" "required_apis" {
  for_each = toset(var.required_apis)

  project = var.project_id
  service = each.value

  disable_dependent_services = var.disable_dependent_services
  disable_on_destroy         = var.disable_on_destroy
}

# Create service account AFTER APIs are enabled
resource "google_service_account" "petclinic_sa" {
  account_id   = var.service_account_name
  display_name = var.service_account_display_name
  project      = var.project_id

  depends_on = [google_project_service.required_apis]
}

# Grant Cloud Build Service Account roles LAST - after both APIs and SA exist
resource "google_project_iam_member" "cloudbuild_roles" {
  for_each = toset(var.service_account_roles)

  project = var.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.petclinic_sa.email}"

  depends_on = [
    google_project_service.required_apis,
    google_service_account.petclinic_sa
  ]
}