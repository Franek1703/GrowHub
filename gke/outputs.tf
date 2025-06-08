# Outputs the public API endpoint of the Kubernetes cluster.
output "cluster_endpoint" {
    description = "The public API endpoint of the Kubernetes cluster."
    value       = google_container_cluster.existing.endpoint
}

# Outputs the base64-encoded cluster CA certificate. Marked as sensitive to prevent accidental exposure.
output "cluster_ca_certificate" {
    description = "The base64-encoded cluster CA certificate. Marked as sensitive to prevent accidental exposure."
    value       = google_container_cluster.existing.master_auth[0].cluster_ca_certificate
    sensitive   = true
}