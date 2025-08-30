# Create global external IP address
resource "google_compute_global_address" "gorilla_clinic_ip" {
  name         = "${var.name}-global-address"
  project      = var.project_id
  description  = "Global IP for HTTPS Load Balancer"
}

# Create HTTPS certificate
resource "google_compute_managed_ssl_certificate" "gorilla_clinic_cert" {
  name        = "${var.name}-cert"
  project     = var.project_id

  managed {
    domains = [var.domain_name]
  }

  lifecycle {
    create_before_destroy = true
  }
}


# Create HTTPS Load Balancer with Cloud Run backend
resource "google_compute_backend_service" "gorilla_clinic_backend" {
  name                  = "${var.name}-backend"
  project              = var.project_id
  protocol             = "HTTPS"
  port_name            = "http"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  timeout_sec          = 30
  enable_cdn           = true

  backend {
    group = google_compute_region_network_endpoint_group.primary_neg.id
    capacity_scaler = 1.0
  }

  backend {
    group = google_compute_region_network_endpoint_group.secondary_neg.id
    capacity_scaler = 1.0
  }

  log_config {
    enable = true
  }

  custom_response_headers = ["X-Load-Balancer-Primary-Region: ${var.primary_service_region}", "X-Load-Balancer-Secondary-Region: ${var.secondary_service_region}"]
}

# Create health check
resource "google_compute_health_check" "gorilla_clinic_health_check" {
  name               = "${var.name}-health-check"
  project           = var.project_id
  timeout_sec       = 5
  check_interval_sec = 10

  http_health_check {
    port               = 80
    port_specification = "USE_FIXED_PORT"
    proxy_header       = "NONE"
    request_path       = "/actuator/health"
  }
}

# Create URL map
resource "google_compute_url_map" "gorilla_clinic_url_map" {
  name            = "${var.name}-url-map"
  project        = var.project_id
  default_service = google_compute_backend_service.gorilla_clinic_backend.id
}

# Create HTTP proxy
resource "google_compute_target_https_proxy" "gorilla_clinic_proxy" {
  name             = "${var.name}-https-proxy"
  project         = var.project_id
  url_map         = google_compute_url_map.gorilla_clinic_url_map.id
  ssl_certificates = [google_compute_managed_ssl_certificate.gorilla_clinic_cert.id]

  lifecycle {
    create_before_destroy = true
  }
}

# Create forwarding rule
resource "google_compute_global_forwarding_rule" "gorilla_clinic_forwarding_rule" {
  name                  = "${var.name}-forwarding-rule"
  project              = var.project_id
  target               = google_compute_target_https_proxy.gorilla_clinic_proxy.id
  port_range           = "443"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  ip_address           = google_compute_global_address.gorilla_clinic_ip.address
}

# Create Network Endpoint Groups (NEGs) for Cloud Run services
resource "google_compute_region_network_endpoint_group" "primary_neg" {
  name                  = "${var.name}-primary-neg"
  project               = var.project_id
  region                = var.primary_service_region
  network_endpoint_type = "SERVERLESS"
  cloud_run {
    service = var.primary_service_name
  }
}

resource "google_compute_region_network_endpoint_group" "secondary_neg" {
  name                  = "${var.name}-secondary-neg"
  project               = var.project_id
  region                = var.secondary_service_region
  network_endpoint_type = "SERVERLESS"
  cloud_run {
    service = var.secondary_service_name
  }
}

