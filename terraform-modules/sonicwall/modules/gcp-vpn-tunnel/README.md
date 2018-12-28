# README

## Overview

The purpose of this module is to create configuration scripts for the SonicWall firewall/router to configure the on-prem side of the VPN tunnel to Google cloud.

The module uses most of the same variables that are also used by the `gcp/modules/shared-vpc` module, which simplifies the VPN tunnel configuration because the values that need to match on both sides of the tunnel (e.g. shared secret key) need to be defined only once.

The module creates but configuration scripts but doesn't execute them. Because of that, it is safe to execute this TF module at any time.

Three configuration scripts are created: one to show configuration, one to configure a VPN tunnel and one to remove the configuration of the VPN tunnel.

The following six files are created:

- `show_config.sh`, which sets env variables and executes `show_config.tcl` using `expect -f`
- `configure.sh`, which sets env variables and executes `configure_vpn_tunnel.tcl` using `expect -f`
- `unconfigure.sh`, which sets env variables and executes `unconfigure_vpn_tunnel.tcl` using `expect -f`

The files are created during Terraform `apply`, nothing happens during Terraform `destroy`.

If Terragrunt is used, the script files will be created in the Terragrunt temporary directory, which in the latest version of Terragrunt is created under the `.terragrunt-cache` directory.

The scripts are created by a Python script, which relies on the `sonicwall` Python module, which combines Tcl fragments to compose the whole Tcl script. This helps keep the Tcl code DRY. The source code for the `sonicwall` Python module is part of this Terraform module.

This TF module defines the `null_resource.subnet_validator` resource, which performs validation of the subnet configuration. The validation is done by calling the `validate_subnets.py` Python script, which relies on the `input_validation` Python package, the source code for which is part of this Terraform module. The `input_validation` package has unit tests that can be executed using `pytest`. At the moment of this writing, there was no CI setup for this code, so the tests must be executed manually.

Valid subnet configurations are:

- one or more primary subnets and zero secondary_1 and secondary_2 subnets
- if primary, secondary_1 and secondary_2 subnets are specifies, the number of subnets should match

> Each subnet configuration requires a name and a CIDR. The number of names and the number of CIDRs should match.

No other validation are performed at this time.

## Script execution

It is important to send commands to SonicWall slowly. This is why, the following `proc` is defined in the Tcl code

```Tcl
proc send_with_pause { cmd } {
    sleep 1
    send $cmd
}
```

and this is most of the rest of the Tcl code uses `send_with_pause` instead of `send`

We had an incident on 9-SEP-2018 where SonicWall hanged. It was caused by the script sending the commands to SonicWall too quickly. Most likely, SonicWall has a buffer for incoming commands, and if that buffer overflows, SonicWall hangs.

It was after that incident that `send_with_pause` was introduced. However, on 16-SEP-2018, there was another incident where SonicWall became unresponsive. The reason for this is unknown at the time of this writing. It seems to be safe to execute `config`/`unconfig` scripts a few times, but it is better to reboot SonicWall after the configuration session is complete.

Below are recommendations for running scripts against SonicWall:

- SonicWall configuration scripts should be executed only during maintenance intervals when the device can be rebooted. Execute the scripts from the office when a person with access to the server room is on site. Take a backup of SonicWall configuration before executing the script(s).
- After the configuration script is executed, the device should be rebooted. It seems to be safe to execute at least 5-6 scripts before the reboot.
- For changes to remote SonicWall (COLO, DR), know the procedure to reboot the device when it cannot be accessed remotely. Basically, know what to do to get the device rebooted if it hangs. Note: the SonicWall at the COLO is a different model (a larger NSA 5600 vs NSA 4600) and both COLO and DR SonicWalls run a different (older) version of firmware.
- When selecting a SonicWall replacement, make sure there are at least two devices that can be rebooted independently from each other. The devices should have good APIs and be fully configurable through code. Test configuration through code before finalizing the purchase.
