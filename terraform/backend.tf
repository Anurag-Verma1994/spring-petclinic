terraform {
  required_version = ">= 1.0.0"
  
  backend "gcs" {
    bucket = "gorilla-clinic-terraform-state"
    prefix = "terraform/state"
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}
