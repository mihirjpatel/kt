## unconfigure tunnel interface
send_with_pause "no tunnel-interface vpn $interface_name $newline"
expect "$config_prompt"
## commit changes
send_with_pause "commit $newline"
expect "$config_prompt"
