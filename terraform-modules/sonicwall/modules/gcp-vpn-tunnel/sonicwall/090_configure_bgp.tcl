# configure BGP
## enter routing mode
send_with_pause "routing $newline"
expect "(config-routing)#"
## enter bpg configuration
send_with_pause "bgp $newline"
expect "ARS BGP>"
send_with_pause "configure terminal $newline"
expect "ARS BGP(config)>"
send_with_pause "router bgp $sonicwall_asn $newline"
expect "ARS BGP(config-router)>"
send_with_pause "neighbor $remote_tunnel_interface_ip remote-as $remote_asn $newline"
expect "ARS BGP(config-router)>"
## send Crtl-Z
send_with_pause "\x1A"
expect "ARS BGP>"
send_with_pause "write $newline"
expect "ARS BGP>"
send_with_pause "exit $newline"
expect "(config-routing)#"
send_with_pause "exit $newline"
expect "$config_prompt"
