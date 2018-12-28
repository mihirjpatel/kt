# Environment variables check - BEGIN
## Check if the environment variables required to run the script were set correctly
if { [info exists env(SONICWALL_HOST)]
    && [info exists env(SONICWALL_USER)]
    && [info exists env(SONICWALL_PASSWD)]
    && [info exists env(SONICWALL_NAME)] } {
    set host $env(SONICWALL_HOST)
    set username $env(SONICWALL_USER)
    set password $env(SONICWALL_PASSWD)
    set sonicwall_device_name $env(SONICWALL_NAME)
} else {
    puts "ERROR: at least some of the environment variables required to run the script are not set"
    puts "See README.md for more info. Exiting with status code 1"
    exit 1
}

if {
    $host == "" ||
    $username == "" ||
    $password == "" ||
    $sonicwall_device_name == "" } {
    puts "ERROR: at least some of the environment variables required to run the script have empty values"
    puts "See README.md for more info. Exiting with status code 1"
    exit 1
}
