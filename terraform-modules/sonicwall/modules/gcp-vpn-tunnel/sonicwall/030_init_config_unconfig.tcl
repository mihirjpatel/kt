# Initialize internal variables
set newline "\n"
set initial_prompt "$username@$sonicwall_device_name>"
set config_prompt  "config($sonicwall_device_name)#"

set vpn_policy_name "gcp-$vpn_tunnel_id"
## interface name does not allow dashes (hyphens), so they need to be replaced by underscores
set vpn_tunnel_id_no_dashes [regsub -all {\-} $vpn_tunnel_id "_"]
set interface_name "gcp_$vpn_tunnel_id_no_dashes\_if"

# Create lists for SonicWall address objects. One list contains names, the other one contains CIDRs

if {
    $number_of_secondary_subnet_names_1 > 0 &&
    $number_of_secondary_subnet_names_2 > 0 } {
    set subnet_names_list [concat $primary_subnet_names_list $secondary_subnet_names_1_list $secondary_subnet_names_2_list]
    set subnet_cidrs_list [concat $primary_subnet_cidrs_list $secondary_subnet_cidrs_1_list $secondary_subnet_cidrs_2_list]
} else {
    set subnet_names_list $primary_subnet_names_list
    set subnet_cidrs_list $primary_subnet_cidrs_list
}

set address_objects_names_list {}
set address_objects_cidrs_list {}
for { set i 0 } { $i < [llength $subnet_names_list] } { incr i } {
    set subnet_name [lindex $subnet_names_list $i]
    set subnet_cidr [lindex $subnet_cidrs_list $i]
    set address_object_name "gcp-$vpn_tunnel_id-$subnet_name"
    # convert CIDR to SonicWall format by adding a space before the slash e.g. "10.24.0.0/24" -> "10.24.0.0 /24"
    set address_object_cidr [regsub -all {\/} $subnet_cidr " /"]
    lappend address_objects_names_list $address_object_name
    lappend address_objects_cidrs_list $address_object_cidr
}

set address_object_group_name "grp-gcp-$vpn_tunnel_id"
