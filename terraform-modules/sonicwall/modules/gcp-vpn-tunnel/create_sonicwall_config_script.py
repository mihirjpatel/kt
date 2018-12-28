#!/usr/bin/env python3

"""This script creates SonicWall configuration scripts"""
import argparse
import os
import stat
from sonicwall import generate_sh
from sonicwall import generate_tcl


def create_script_file(script_name, script_text):
    if os.path.exists(script_name):
        os.remove(script_name)
    f = open(script_name, "a")
    f.write(script_text)
    f.close


def make_executable(sh_script_name):
    st = os.stat(sh_script_name)
    os.chmod(sh_script_name, st.st_mode |
             stat.S_IXUSR | stat.S_IXGRP | stat.S_IXOTH)


def main():
    """Create SonicWall configuration scripts"""

    parser = argparse.ArgumentParser()
    parser.add_argument('--script', required=True,
                        choices=['configure', 'unconfigure', 'show-config'])
    parser.add_argument('--sonicwall_host', required=True)
    parser.add_argument('--sonicwall_user', required=True)
    parser.add_argument('--sonicwall_passwd', required=True)
    parser.add_argument('--sonicwall_name', required=True)
    parser.add_argument('--ssh_settings', default="")
    parser.add_argument('--vpn_tunnel_id')
    parser.add_argument('--sonicwall_vpn_shared_key')
    parser.add_argument('--sonicwall_asn')
    parser.add_argument('--gcp_asn')
    parser.add_argument('--gcp_tunnel_interface_ip')
    parser.add_argument('--sonicwall_tunnel_interface_ip')
    parser.add_argument('--sonicwall_tunnel_interface_netmask')
    parser.add_argument('--gcp_vpn_gateway_dns_name')
    parser.add_argument('--primary_subnet_names')
    parser.add_argument('--primary_subnet_cidrs')
    parser.add_argument('--secondary_subnet_names_1')
    parser.add_argument('--secondary_subnet_cidrs_1')
    parser.add_argument('--secondary_subnet_names_2')
    parser.add_argument('--secondary_subnet_cidrs_2')

    args = parser.parse_args()

    show_config = dict(sonicwall_host=args.sonicwall_host,
                       sonicwall_user=args.sonicwall_user,
                       sonicwall_passwd=args.sonicwall_passwd,
                       sonicwall_name=args.sonicwall_name,
                       ssh_settings=args.ssh_settings)

    configure_unconfigure_config = dict(sonicwall_host=args.sonicwall_host,
                                        sonicwall_user=args.sonicwall_user,
                                        sonicwall_passwd=args.sonicwall_passwd,
                                        sonicwall_name=args.sonicwall_name,
                                        ssh_settings=args.ssh_settings,
                                        vpn_tunnel_id=args.vpn_tunnel_id,
                                        sonicwall_vpn_shared_key=args.sonicwall_vpn_shared_key,
                                        sonicwall_asn=args.sonicwall_asn,
                                        gcp_asn=args.gcp_asn,
                                        gcp_tunnel_interface_ip=args.gcp_tunnel_interface_ip,
                                        sonicwall_tunnel_interface_ip=args.sonicwall_tunnel_interface_ip,
                                        sonicwall_tunnel_interface_netmask=args.sonicwall_tunnel_interface_netmask,
                                        gcp_vpn_gateway_dns_name=args.gcp_vpn_gateway_dns_name,
                                        primary_subnet_names=args.primary_subnet_names,
                                        primary_subnet_cidrs=args.primary_subnet_cidrs,
                                        secondary_subnet_names_1=args.secondary_subnet_names_1,
                                        secondary_subnet_cidrs_1=args.secondary_subnet_cidrs_1,
                                        secondary_subnet_names_2=args.secondary_subnet_names_2,
                                        secondary_subnet_cidrs_2=args.secondary_subnet_cidrs_2)

    if args.script == "configure":
        sh_script_name = "configure.sh"
        tcl_script_name = "configure_vpn_tunnel.tcl"
        sh_script_text = generate_sh.get_sh_script(
            tcl_script_name, configure_unconfigure_config)
        tcl_script_text = generate_tcl.configure()
    elif args.script == "unconfigure":
        sh_script_name = "unconfigure.sh"
        tcl_script_name = "unconfigure_vpn_tunnel.tcl"
        sh_script_text = generate_sh.get_sh_script(
            tcl_script_name, configure_unconfigure_config)
        tcl_script_text = generate_tcl.unconfigure()
    elif args.script == "show-config":
        sh_script_name = "show_config.sh"
        tcl_script_name = "show_config.tcl"
        sh_script_text = generate_sh.get_sh_script(
            tcl_script_name, show_config)
        tcl_script_text = generate_tcl.show_config()
    else:
        print("Unsupported values for the action switch")
        exit(1)

    create_script_file(tcl_script_name, tcl_script_text)
    create_script_file(sh_script_name, sh_script_text)
    make_executable(sh_script_name)


if __name__ == "__main__":
    main()
