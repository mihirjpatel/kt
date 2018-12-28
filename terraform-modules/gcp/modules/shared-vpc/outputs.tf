output "shared_vpc_project_id" {
  value = "${google_project.shared_vpc_project.project_id}"
}

output "shared_vpc_network_name" {
  value = "${google_compute_network.vpc.name}"
}
