# unconfigure address group
send_with_pause "no address-group ipv4 $address_object_group_name $newline"
expect "$config_prompt"
## commit changes
send_with_pause "commit $newline"
expect "$config_prompt"

## unconfigure address objects
for { set i 0 } { $i < [llength $address_objects_names_list] } { incr i } {
    set address_object_name [lindex $address_objects_names_list $i]
    set cmd "no address-object ipv4 $address_object_name $newline"
    send_with_pause $cmd
    expect "$config_prompt"
}

## commit changes
send_with_pause "commit $newline"
expect "$config_prompt"

send_with_pause "exit $newline"
expect "$config_prompt"
