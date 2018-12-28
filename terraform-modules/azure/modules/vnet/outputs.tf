output "vnet_resource_group_name" {
  description = "The name of Azure resource group where the resources for the newly created vNet reside"
  value       = "${azurerm_resource_group.rg_vnet.name}"
}

output "vnet_resource_group_id" {
  description = "The ID of Azure resource group where the resources for the newly created vNet reside"
  value       = "${azurerm_resource_group.rg_vnet.id}"
}

output "vnet_name" {
  description = "The Name of the newly created vNet"
  value       = "${azurerm_virtual_network.vnet.name}"
}

output "vnet_id" {
  description = "The id of the newly created vNet"
  value       = "${azurerm_virtual_network.vnet.id}"
}

output "vnet_location" {
  description = "The location of the newly created vNet"
  value       = "${azurerm_virtual_network.vnet.location}"
}

output "vnet_address_space" {
  description = "The address space of the newly created vNet"
  value       = "${azurerm_virtual_network.vnet.address_space}"
}

output "vnet_user_subnet_names" {
  description = "The names of user subnets created inside the newly created vNet"
  value       = ["${azurerm_subnet.user_subnet.*.name}"]
}

output "vnet_user_subnet_ids" {
  description = "The ids of user subnets created inside the newly created vNet"
  value       = ["${azurerm_subnet.user_subnet.*.id}"]
}

output "vnet_user_subnet_address_spaces" {
  description = "The address spaces of user subnets created inside the newly created vNet"
  value       = ["${azurerm_subnet.user_subnet.*.address_prefix}"]
}
