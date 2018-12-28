output "k8s_cluster_name" {
  value = "${google_container_cluster.k8s_cluster.name}"
}

output "email" {
  value       = "${google_service_account.storage_admin.email}"
  description = "The e-mail address of the service account."
}
