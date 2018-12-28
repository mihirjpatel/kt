# configure firewall rules
## open everything from VPN to LAN
send_with_pause "access-rule from VPN to LAN action allow source address group $address_object_group_name \
    port any service any destination address group \"LAN Subnets\" $newline"
expect "#"
send_with_pause "exit $newline"
expect "$config_prompt"
## open everything from LAN to VPN
send_with_pause "access-rule from LAN to VPN action allow source address group \"LAN Subnets\" \
    port any service any destination address group $address_object_group_name $newline"
expect "#"
send_with_pause "exit $newline"
expect "$config_prompt"
## commit changes
send_with_pause "commit $newline"
expect "$config_prompt"
