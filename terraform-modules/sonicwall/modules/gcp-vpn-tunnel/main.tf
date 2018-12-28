resource "null_resource" "subnet_validator" {
  provisioner "local-exec" {
    command = <<EOF

  ./validate_subnets.py \
  --primary_subnet_names "${join(",", var.subnet_names)}" \
  --primary_subnet_cidrs "${join(",", var.subnet_cidrs)}" \
  --secondary_subnet_names_1 "${join(",", var.secondary_ip_range_gke_cluster_pods_names)}" \
  --secondary_subnet_cidrs_1 "${join(",", var.secondary_ip_range_gke_cluster_pods_cidrs)}" \
  --secondary_subnet_names_2 "${join(",", var.secondary_ip_range_gke_cluster_services_names)}" \
  --secondary_subnet_cidrs_2 "${join(",", var.secondary_ip_range_gke_cluster_services_cidrs)}"
  EOF
  }
}

resource "null_resource" "sonicwall_show_config_script" {
  provisioner "local-exec" {
    command = <<EOF

  ./create_sonicwall_config_script.py --script "show-config" \
  --sonicwall_host "${var.sonicwall_host}" \
  --sonicwall_user "${var.sonicwall_user}" \
  --sonicwall_passwd "${var.sonicwall_passwd}" \
  --sonicwall_name "${var.sonicwall_name}" \
  --ssh_settings "${var.ssh_settings}"
  EOF
  }

  depends_on = [
    "null_resource.subnet_validator",
  ]
}

resource "null_resource" "sonicwall_config_script" {
  provisioner "local-exec" {
    command = <<EOF

  ./create_sonicwall_config_script.py --script "configure" \
  --sonicwall_host "${var.sonicwall_host}" \
  --sonicwall_user "${var.sonicwall_user}" \
  --sonicwall_passwd "${var.sonicwall_passwd}" \
  --sonicwall_name "${var.sonicwall_name}" \
  --ssh_settings "${var.ssh_settings}" \
  --vpn_tunnel_id "${var.vpn_tunnel_id}" \
  --sonicwall_vpn_shared_key "${var.vpn_connection_shared_key}" \
  --sonicwall_asn "${var.onprem_peer_asn}" \
  --gcp_asn "${var.cloud_router_asn}" \
  --gcp_tunnel_interface_ip "${var.cloud_router_link_local_ip}" \
  --sonicwall_tunnel_interface_ip "${var.onprem_device_link_local_ip}" \
  --sonicwall_tunnel_interface_netmask "255.255.255.252" \
  --gcp_vpn_gateway_dns_name "${var.vpn_tunnel_id}-gateway.${var.dns_zone_dns_name}" \
  --primary_subnet_names "${join(",", var.subnet_names)}" \
  --primary_subnet_cidrs "${join(",", var.subnet_cidrs)}" \
  --secondary_subnet_names_1 "${join(",", var.secondary_ip_range_gke_cluster_pods_names)}" \
  --secondary_subnet_cidrs_1 "${join(",", var.secondary_ip_range_gke_cluster_pods_cidrs)}" \
  --secondary_subnet_names_2 "${join(",", var.secondary_ip_range_gke_cluster_services_names)}" \
  --secondary_subnet_cidrs_2 "${join(",", var.secondary_ip_range_gke_cluster_services_cidrs)}"
  EOF
  }

  depends_on = [
    "null_resource.subnet_validator",
  ]
}

resource "null_resource" "sonicwall_unconfig_script" {
  provisioner "local-exec" {
    command = <<EOF

  ./create_sonicwall_config_script.py --script "unconfigure" \
  --sonicwall_host "${var.sonicwall_host}" \
  --sonicwall_user "${var.sonicwall_user}" \
  --sonicwall_passwd "${var.sonicwall_passwd}" \
  --sonicwall_name "${var.sonicwall_name}" \
  --ssh_settings "${var.ssh_settings}" \
  --vpn_tunnel_id "${var.vpn_tunnel_id}" \
  --sonicwall_vpn_shared_key "${var.vpn_connection_shared_key}" \
  --sonicwall_asn "${var.onprem_peer_asn}" \
  --gcp_asn "${var.cloud_router_asn}" \
  --gcp_tunnel_interface_ip "${var.cloud_router_link_local_ip}" \
  --sonicwall_tunnel_interface_ip "${var.onprem_device_link_local_ip}" \
  --sonicwall_tunnel_interface_netmask "255.255.255.252" \
  --gcp_vpn_gateway_dns_name "${var.vpn_tunnel_id}-gateway.${var.dns_zone_dns_name}" \
  --primary_subnet_names "${join(",", var.subnet_names)}" \
  --primary_subnet_cidrs "${join(",", var.subnet_cidrs)}" \
  --secondary_subnet_names_1 "${join(",", var.secondary_ip_range_gke_cluster_pods_names)}" \
  --secondary_subnet_cidrs_1 "${join(",", var.secondary_ip_range_gke_cluster_pods_cidrs)}" \
  --secondary_subnet_names_2 "${join(",", var.secondary_ip_range_gke_cluster_services_names)}" \
  --secondary_subnet_cidrs_2 "${join(",", var.secondary_ip_range_gke_cluster_services_cidrs)}"
  EOF
  }

  depends_on = [
    "null_resource.subnet_validator",
  ]
}
