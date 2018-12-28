#!/usr/bin/env python3

import argparse
from input_validation.gcp_subnets import GcpSubnets


def get_subnet_info_from_args():
    parser = argparse.ArgumentParser()
    parser.add_argument('--primary_subnet_names')
    parser.add_argument('--primary_subnet_cidrs')
    parser.add_argument('--secondary_subnet_names_1')
    parser.add_argument('--secondary_subnet_cidrs_1')
    parser.add_argument('--secondary_subnet_names_2')
    parser.add_argument('--secondary_subnet_cidrs_2')

    args = parser.parse_args()

    subnet_config = GcpSubnets(
        args.primary_subnet_names,
        args.primary_subnet_cidrs,
        args.secondary_subnet_names_1,
        args.secondary_subnet_cidrs_1,
        args.secondary_subnet_names_2,
        args.secondary_subnet_cidrs_2
    )

    return subnet_config


if __name__ == "__main__":

    subnet_config = get_subnet_info_from_args()

    is_subnet_config_valid = subnet_config.are_subnet_parameters_ok()

    if is_subnet_config_valid:
        exit(0)
    else:
        print("ERROR: configuration of primary and/or secondary subnets is incorrect")
        exit(1)
