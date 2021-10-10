terraform {
  backend "gcs" {
    bucket  = "GIVE THE GCP BUCKET NAME"
    prefix  = "terraform/state"
  }
}
