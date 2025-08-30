resource "google_dns_managed_zone" "petclinic" {
  name        = "petclinic-zone"
  dns_name    = "${var.domain_name}."
  description = "DNS zone for PetClinic application"
}

# Global DNS record pointing to the global load balancer
resource "google_dns_record_set" "global" {
  name         = google_dns_managed_zone.petclinic.dns_name
  type         = "A"
  ttl          = 300
  managed_zone = google_dns_managed_zone.petclinic.name
  rrdatas      = [var.global_lb_ip]    # Using the global load balancer IP
}
