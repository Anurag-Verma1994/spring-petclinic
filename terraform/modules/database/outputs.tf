output "primary_instance_name" {
  description = "The name of the primary database instance"
  value       = google_sql_database_instance.primary.name
}

output "secondary_instance_name" {
  description = "The name of the secondary database instance"
  value       = google_sql_database_instance.secondary.name
}

output "primary_connection_name" {
  description = "The connection name of the primary instance"
  value       = google_sql_database_instance.primary.connection_name
}

output "secondary_connection_name" {
  description = "The connection name of the secondary instance"
  value       = google_sql_database_instance.secondary.connection_name
}

output "primary_ip" {
  description = "The IP address of the primary instance"
  value       = google_sql_database_instance.primary.public_ip_address
}

output "secondary_ip" {
  description = "The IP address of the secondary instance"
  value       = google_sql_database_instance.secondary.public_ip_address
}

output "database_name" {
  description = "The name of the database"
  value       = google_sql_database.database.name
}

output "database_username_secret" {
  description = "The name of the secret containing the database username"
  value       = data.google_secret_manager_secret_version.db_username.secret
}

output "database_password_secret" {
  description = "The name of the secret containing the database password"
  value       = data.google_secret_manager_secret_version.db_password.secret
}

output "database_connection_secret" {
  description = "The name of the secret containing the database connection information"
  value       = data.google_secret_manager_secret_version.db_connection.secret
}
