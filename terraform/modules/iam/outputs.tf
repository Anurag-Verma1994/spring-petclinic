output "service_account_email" {
  description = "Email of the created service account"
  value       = google_service_account.petclinic_sa.email
}

output "service_account_name" {
  description = "Name of the created service account"
  value       = google_service_account.petclinic_sa.name
}

output "service_account_id" {
  description = "ID of the created service account"
  value       = google_service_account.petclinic_sa.account_id
}
