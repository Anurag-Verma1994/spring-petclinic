terraform {
  required_version = ">= 1.0.0"

  backend "gcs" {
    bucket = "gorilla-clinic-terraform-state"
    prefix = "terraform/state/prod"
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.primary_region
}
