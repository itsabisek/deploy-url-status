# Define the provider
provider "google" {
  credentials = file(var.sa_creds)
  project     = var.gcp_project
  region      = var.gcp_region
  zone        = var.gcp_zone

}
