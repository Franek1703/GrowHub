terraform {
  required_version = ">= 1.6"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.12"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = "europe-central2"
}