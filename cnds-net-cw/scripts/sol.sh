#!/bin/bash

set -xe

shopt -s expand_aliases

. alias.sh

## Step 1

# Configure h1
## Example use
#h1 ip addr add 10.1.0.2/24 brd + dev h1-eth0 # Configure the interface IP
#h1 ip route add default via 10.1.0.1 dev h1-eth0 # Configure the routing table

# Configure r1

# Configure h2

# Configure r2

# Configure h3

# Configure h4

# Configure r3

## Step 2
# Enable NAT on r3

# Allow traffic from r3-eth0 to r3-eth1 and r3-eth2

# Allow established returning traffic from r3-eth1 and r3-2th2 to r3-eth0

# Drop all other traffic
