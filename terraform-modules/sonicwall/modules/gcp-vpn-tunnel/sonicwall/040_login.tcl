set timeout 5

if { [info exists env(SSH_SETTINGS)] } {
    set ssh_settings $env(SSH_SETTINGS)
} else {
    set ssh_settings ""
}

# establish a SonicWall CLI session over SSH
if { $ssh_settings == "" } {
    spawn ssh $username@$host
} else {
    spawn ssh $ssh_settings $username@$host
}

expect {
    timeout { puts "timed out"; exit 1 }
    "Connection refused" { exit 1 }
    "unknown host" { exit 1 }
    "DH GEX group out of range" { exit 1 }
    "password:"
}

# log into SonicWall CLI interface
send "$password$newline" ;# no space after password and before newline

expect {
    "Access denied" { exit 1 }
    "$initial_prompt"
}

send "configure $newline"

expect {
    timeout { puts "timed out"; exit 1 }
    "Do you wish to preempt them (yes/no)?" {
        puts "\nERROR: Another administrative session is in progress. Aborting"
        exit 1
    }
    "$config_prompt"
}

# turn off paged output for this session
send "no cli pager session $newline"

expect "$config_prompt"

set timeout 1
