terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "azurerm" {}
}

locals {
  k8s_cluster_resource_group_name  = "k8s-${var.environment}-rg"
  k8s_cluster_name                 = "k8s-${var.environment}"
  k8s_cluster_dns_prefix           = "k8s-${var.environment}"
  k8s_cluster_subnet_name          = "k8s"
  k8s_cluster_subnet_address_space = "${var.vnet_address_space_prefix_x_y}.8.0/24"
  k8s_cluster_service_cidr         = "${var.vnet_address_space_prefix_x_y}.10.0/24"
  k8s_cluster_dns_service_ip       = "${var.vnet_address_space_prefix_x_y}.10.10"

  extra_tags = {
    tag_version = 2
    iac         = "true"
    environment = "${var.environment}"
  }

  tags = "${merge(var.tags, local.extra_tags)}"
}

data "azurerm_subnet" "k8s_subnet" {
  name                 = "${var.vnet_k8s_subnet_name}"
  virtual_network_name = "${var.vnet_name}"
  resource_group_name  = "${var.vnet_resource_group_name}"
}

resource "azurerm_resource_group" "k8s" {
  name     = "${local.k8s_cluster_resource_group_name}"
  location = "${var.location}"
}

resource "null_resource" "k8s" {
  provisioner "local-exec" {
    command = <<EOF
az aks create \
  --kubernetes-version    "1.10.5" \
  --name                  "${local.k8s_cluster_name}" \
  --resource-group        "${azurerm_resource_group.k8s.name}" \
  --dns-name-prefix       "${local.k8s_cluster_dns_prefix}" \
  --admin-username        "ubuntu" \
  --service-principal     "${var.client_id}" \
  --client-secret         "${var.client_secret}" \
  --location              "${azurerm_resource_group.k8s.location}" \
  --node-count            "${var.k8s_agent_count}" \
  --node-osdisk-size      "30" \
  --node-vm-size          "Standard_DS1_v2" \
  --ssh-key-value         "${file("${var.k8s_ssh_public_key}")}" \
  --network-plugin        "azure" \
  --vnet-subnet-id        "${data.azurerm_subnet.k8s_subnet.id}" \
  --docker-bridge-address "172.17.0.1/16" \
  --service-cidr          "${local.k8s_cluster_service_cidr}" \
  --dns-service-ip        "${local.k8s_cluster_dns_service_ip}" \
  --enable-addons         "http_application_routing" \
  --max-pods              "30"
# 30 is the default value for max-pods
#[--enable-rbac]
#[--workspace-resource-id]
#[--tags]
#
#[--pod-cidr]
#
#[--aad-client-app-id]
#[--aad-server-app-id]
#[--aad-server-app-secret]
#[--aad-tenant-id]
#
#[--generate-ssh-keys]
#[--no-ssh-key]
#[--no-wait]
EOF
  }

  provisioner "local-exec" {
    when = "destroy"

    command = <<EOF
az aks delete \
  --name              "${local.k8s_cluster_name}" \
  --resource-group    "${local.k8s_cluster_resource_group_name}" \
  --yes
EOF
  }

  depends_on = ["azurerm_resource_group.k8s"]
}
