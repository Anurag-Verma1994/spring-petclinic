output "load_balancer_ip" {
  description = "The IP address of the global load balancer"
  value       = google_compute_global_address.gorilla_clinic_ip.address
}
