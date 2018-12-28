#!/bin/bash

set -e

sudo sh -c "echo \"192.168.1.250 artnet-ny-dc1.artnet.local\" >> /etc/hosts"
sudo sh -c "echo \"192.168.1.251 artnet-ny-dc2.artnet.local\" >> /etc/hosts"