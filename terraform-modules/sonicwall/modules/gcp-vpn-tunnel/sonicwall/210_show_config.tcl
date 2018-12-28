send_with_pause "show interfaces ipv4 $newline"
expect "$config_prompt"
send_with_pause "show vpn policies $newline"
expect "$config_prompt"
send_with_pause "show access-rules ipv4 $newline"
expect "$config_prompt"
send_with_pause "show address-objects custom $newline"
expect "$config_prompt"
send_with_pause "show address-groups custom $newline"
expect "$config_prompt"

# show BGP configuration
## enter routing mode
send_with_pause "routing $newline"
expect "(config-routing)#"
## enter bpg configuration
send_with_pause "bgp $newline"
expect "ARS BGP>"
send_with_pause "show ip bgp summary $newline"
expect "ARS BGP>"
send_with_pause "exit $newline"
expect "(config-routing)#"
send_with_pause "exit $newline"
expect "$config_prompt"
