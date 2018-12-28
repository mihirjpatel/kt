## Check if the environment variables required to run the script were set
if {   [info exists env(VPN_TUNNEL_ID)]
    && [info exists env(SONICWALL_HOST)]
    && [info exists env(SONICWALL_USER)]
    && [info exists env(SONICWALL_PASSWD)]
    && [info exists env(SONICWALL_NAME)]
    && [info exists env(SONICWALL_VPN_SHARED_KEY)]
    && [info exists env(SONICWALL_ASN)]
    && [info exists env(GCP_ASN)]
    && [info exists env(GCP_TUNNEL_INTERFACE_IP)]
    && [info exists env(SONICWALL_TUNNEL_INTERFACE_IP)]
    && [info exists env(SONICWALL_TUNNEL_INTERFACE_NETMASK)]
    && [info exists env(GCP_VPN_GATEWAY_DNS_NAME)]
    && [info exists env(PRIMARY_SUBNET_NAMES)]
    && [info exists env(PRIMARY_SUBNET_CIDRS)]
    && [info exists env(SECONDARY_SUBNET_NAMES_1)]
    && [info exists env(SECONDARY_SUBNET_CIDRS_1)]
    && [info exists env(SECONDARY_SUBNET_NAMES_2)]
    && [info exists env(SECONDARY_SUBNET_CIDRS_2)]} {
    set vpn_tunnel_id $env(VPN_TUNNEL_ID)
    set host $env(SONICWALL_HOST)
    set username $env(SONICWALL_USER)
    set password $env(SONICWALL_PASSWD)
    set sonicwall_device_name $env(SONICWALL_NAME)
    set vpn_connection_shared_key $env(SONICWALL_VPN_SHARED_KEY)
    set sonicwall_asn $env(SONICWALL_ASN)
    set remote_asn $env(GCP_ASN)
    set remote_tunnel_interface_ip $env(GCP_TUNNEL_INTERFACE_IP)
    set sonicwall_tunnel_interface_ip $env(SONICWALL_TUNNEL_INTERFACE_IP)
    set tunnel_interface_netmask $env(SONICWALL_TUNNEL_INTERFACE_NETMASK)
    set vpn_gateway_dns_name $env(GCP_VPN_GATEWAY_DNS_NAME)
    set primary_subnet_names_csv $env(PRIMARY_SUBNET_NAMES)
    set primary_subnet_cidrs_csv $env(PRIMARY_SUBNET_CIDRS)
    set secondary_subnet_names_1_csv $env(SECONDARY_SUBNET_NAMES_1)
    set secondary_subnet_cidrs_1_csv $env(SECONDARY_SUBNET_CIDRS_1)
    set secondary_subnet_names_2_csv $env(SECONDARY_SUBNET_NAMES_2)
    set secondary_subnet_cidrs_2_csv $env(SECONDARY_SUBNET_CIDRS_2)
} else {
    puts "ERROR: at least some of the environment variables required to run the script are not set"
    puts "See README.md for more info. Exiting with status code 1"
    exit 1
}

# remove the trailing dot frome the DNS name, if it exists
set vpn_gateway_dns_name_sonicwall_format [regsub {\.$} $vpn_gateway_dns_name ""]


## Show diagnostics info
puts ""
puts "Here is the input data:"
puts [format "    vpn_tunnel_id: %s"                            $vpn_tunnel_id]
puts [format "    host: %s"                                     $host]
puts [format "    username: %s"                                 $username]
puts [format "    password: %s"                                 "(sensitive)"]
puts [format "    sonicwall_device_name: %s"                    $sonicwall_device_name]
puts [format "    vpn_connection_shared_key: %s"                "(sensitive)"]
puts [format "    sonicwall_asn: %s"                            $sonicwall_asn]
puts [format "    remote_asn: %s"                               $remote_asn]
puts [format "    remote_tunnel_interface_ip: %s"               $remote_tunnel_interface_ip]
puts [format "    sonicwall_tunnel_interface_ip: %s"            $sonicwall_tunnel_interface_ip]
puts [format "    tunnel_interface_netmask: %s"                 $tunnel_interface_netmask]
puts [format "    vpn_gateway_dns_name: %s"                     $vpn_gateway_dns_name]
puts [format "    vpn_gateway_dns_name_sonicwall_format: %s"    $vpn_gateway_dns_name_sonicwall_format]
puts [format "    primary_subnet_names_csv: %s"                 $primary_subnet_names_csv]
puts [format "    primary_subnet_cidrs_csv: %s"                 $primary_subnet_cidrs_csv]
puts [format "    secondary_subnet_names_1_csv: %s"             $secondary_subnet_names_1_csv]
puts [format "    secondary_subnet_cidrs_1_csv: %s"             $secondary_subnet_cidrs_1_csv]
puts [format "    secondary_subnet_names_2_csv: %s"             $secondary_subnet_names_2_csv]
puts [format "    secondary_subnet_cidrs_2_csv: %s"             $secondary_subnet_cidrs_2_csv]

if {
    $vpn_tunnel_id == "" ||
    $host == "" ||
    $username == "" ||
    $password == "" ||
    $sonicwall_device_name == "" ||
    $vpn_connection_shared_key == "" ||
    $sonicwall_asn == "" ||
    $remote_asn == "" ||
    $remote_tunnel_interface_ip == "" ||
    $sonicwall_tunnel_interface_ip == "" ||
    $tunnel_interface_netmask == "" ||
    $vpn_gateway_dns_name == "" ||
    $primary_subnet_names_csv == "" ||
    $primary_subnet_cidrs_csv == "" } {
    puts "ERROR: at least some of the environment variables required to run the script have empty values"
    puts "See README.md for more info. Exiting with status code 1"
    exit 1
}

## Check subnet parameters. Two main cases are possible:
## - primary range is passed but not the secondary ones, any non-zero number of primary subnets is OK
## - if both primary and secondary ranges are passed, the number of subnets everywhere should be the same
## Note:
## - we are not verifying if the subnet CIDRs were formatted correctly

if { $primary_subnet_names_csv == "" } {
    set number_of_primary_subnet_names 0
} else {
    set primary_subnet_names_list [ split $primary_subnet_names_csv , ]
    set number_of_primary_subnet_names [ llength $primary_subnet_names_list ]
}

if { $primary_subnet_cidrs_csv == "" } {
    set number_of_primary_subnet_cidrs 0
} else {
    set primary_subnet_cidrs_list [ split $primary_subnet_cidrs_csv , ]
    set number_of_primary_subnet_cidrs [ llength $primary_subnet_cidrs_list ]
}

if { $secondary_subnet_names_1_csv == "" } {
    set number_of_secondary_subnet_names_1 0
} else {
    set secondary_subnet_names_1_list [ split $secondary_subnet_names_1_csv , ]
    set number_of_secondary_subnet_names_1 [ llength $secondary_subnet_names_1_list ]
}

if { $secondary_subnet_cidrs_1_csv == "" } {
    set number_of_secondary_subnet_cidrs_1 0
} else {
    set secondary_subnet_cidrs_1_list [ split $secondary_subnet_cidrs_1_csv , ]
    set number_of_secondary_subnet_cidrs_1 [ llength $secondary_subnet_cidrs_1_list ]
}

if { $secondary_subnet_names_2_csv == "" } {
    set number_of_secondary_subnet_names_2 0
} else {
    set secondary_subnet_names_2_list [ split $secondary_subnet_names_2_csv , ]
    set number_of_secondary_subnet_names_2 [ llength $secondary_subnet_names_2_list ]
}

if { $secondary_subnet_cidrs_2_csv == "" } {
    set number_of_secondary_subnet_cidrs_2 0
} else {
    set secondary_subnet_cidrs_2_list [ split $secondary_subnet_cidrs_2_csv , ]
    set number_of_secondary_subnet_cidrs_2 [ llength $secondary_subnet_cidrs_2_list ]
}
