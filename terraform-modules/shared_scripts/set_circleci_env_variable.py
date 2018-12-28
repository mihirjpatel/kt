#!/usr/bin/env python3
"""
Sets a single circleci environment variable via their v1.1 API interface
"""

import argparse
import os
import requests
import json
import sys


def set_circleci_env_variable(key, value, github_owner, github_repo, circle_token):
    """Sets a circleci env variable"""

    url = "https://circleci.com/api/v1.1/project/github/%s/%s/envvar?circle-token=%s" % (github_owner, github_repo, circle_token)
    payload = { 'name': key, 'value': value }
    response = requests.post(url, json=payload)
    response.raise_for_status()
    print('Updated circleci key: ' + key)


def main():
    """Sets a circleci env variable from the CLI"""

    parser = argparse.ArgumentParser()
    parser.add_argument('--key', required=True)
    parser.add_argument('--value', required=True)
    args = parser.parse_args()

    github_owner=os.environ['GITHUB_OWNER']
    github_repo=os.environ['GITHUB_REPO']
    circle_token=os.environ['CIRCLECI_TOKEN']

    set_circleci_env_variable(args.key, args.value, github_owner, github_repo, circle_token)


if __name__ == "__main__":
    main()
