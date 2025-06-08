resource "google_container_cluster" "existing" {
  name             = "francesko-kluster1"
  location         = "europe-central2"
  enable_autopilot = true
}