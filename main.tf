provider "google-beta" {
  # credentials = file("~/.config/gcloud/credentials-stage.json") # stage
  project = var.project
  region  = var.region
}

terraform {
  backend "gcs" {
    bucket = "martin-bidder-state-ci-cd"

    // State file prefix in Google Cloud Storage Bucket
    prefix = "terraform/state"
  }
}


#########################################################################
#
#                       Cloud Build Triggers
#
#########################################################################

locals {
  bidder_repo_name = "martin-bidder"
}

resource "google_cloudbuild_trigger" "grafana-production" {
  provider       = google-beta
  project        = var.project
  description    = "Grafana Backup: martin-bidder-prod"
  filename       = "cloudbuild.yaml"
  disabled       = false
  included_files = ["./**"]

  github {
    name  = "grafana-backup-tool"
    owner = "martinai"
    push {
      branch = "^master$"
    }
  }
}
