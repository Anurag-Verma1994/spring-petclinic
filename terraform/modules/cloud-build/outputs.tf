output "app_trigger_id" {
  description = "ID of the application trigger"
  value       = google_cloudbuild_trigger.app_trigger.id
}

output "infrastructure_trigger_id" {
  description = "ID of the infrastructure trigger"
  value       = google_cloudbuild_trigger.infrastructure_trigger.id
}