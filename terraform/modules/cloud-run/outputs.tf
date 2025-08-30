output "service_name" {
  description = "The name of the Cloud Run service"
  value       = google_cloud_run_service.service.name
}
