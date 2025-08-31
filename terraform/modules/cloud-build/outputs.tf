output "app_trigger_id" {
  description = "ID of the application trigger"
  value       = google_cloudbuild_trigger.app_trigger.id
}

output "infrastructure_trigger_ids" {
  description = "Map of environment names to their respective infrastructure trigger IDs"
  value       = { for k, v in google_cloudbuild_trigger.infrastructure_triggers : k => v.id }
}