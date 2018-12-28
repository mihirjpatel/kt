# unconfigure firewall rules
send_with_pause "no access-rule from VPN to LAN action allow source address group $address_object_group_name \
    port any service any destination address group \"LAN Subnets\" $newline"
expect "$config_prompt"
send_with_pause "no access-rule from LAN to VPN action allow source address group \"LAN Subnets\" \
    port any service any destination address group $address_object_group_name $newline"
expect "$config_prompt"
## commit changes
send_with_pause "commit $newline"
expect "$config_prompt"
