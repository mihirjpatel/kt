## unconfigure vpn policy for the tunnel interface
send_with_pause "no vpn policy tunnel-interface $vpn_policy_name $newline"
expect "$config_prompt"
send_with_pause "commit $newline"
expect "$config_prompt"
