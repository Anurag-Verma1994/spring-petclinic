output "primary_service_url" {
  value = module.cloud_run_primary.service_url
}

output "secondary_service_url" {
  value = module.cloud_run_secondary.service_url
}

output "app_trigger_id" {
  value = module.cloud_build.app_trigger_id
}

output "infrastructure_trigger_ids" {
  description = "Map of environment names to their respective infrastructure trigger IDs"
  value = module.cloud_build.infrastructure_trigger_ids
}
