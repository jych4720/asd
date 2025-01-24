#!/bin/bash

set -xe

shopt -s expand_aliases

. alias.sh

## Step 1

# Configure h1
## Example use
#h1 ip addr add 10.1.0.2/24 brd + dev h1-eth0 # Configure the interface IP
#h1 ip route add default via 10.1.0.1 dev h1-eth0 # Configure the routing table

h1 ip addr add 1.1.0.1/24 dev h1-eth0   
h1 ip link set h1-eth0 up                
h1 ip route add default via 1.1.0.254 dev h1-eth0  

# Configure r1
r1 ip addr add 1.1.0.254/24 dev r1-eth0   
r1 ip addr add 1.0.1.1/30 dev r1-eth1     
r1 ip route add 1.2.0.0/24 via 1.0.1.2
r1 ip link set r1-eth0 up                 
r1 ip link set r1-eth1 up                 

r1 ip addr add 1.0.2.1/24 dev r1-eth2
r1 ip link set r1-eth2 up
r1 ip route add 10.0.0.0/24 via 1.0.2.2
# Configure h2
h2 ip addr add 1.2.0.1/24 dev h2-eth0     
h2 ip link set h2-eth0 up                 
h2 ip route add default via 1.2.0.254 dev h2-eth0  

# Configure r2
r2 ip addr add 1.2.0.254/24 dev r2-eth0   
r2 ip addr add 1.0.1.2/30 dev r2-eth1     
r2 ip route add 1.1.0.0/24 via 1.0.1.1
r2 ip link set r2-eth0 up                 
r2 ip link set r2-eth1 up                

r2 ip addr add 1.0.3.1/24 dev r2-eth2
r2 ip route add 10.0.0.0/24 via 1.0.3.2
r2 ip link set r2-eth2 up
# Configure h3
h3 ip addr add 10.0.0.2/24 dev h3-eth0
h3 ip link set h3-eth0 up
h3 ip route add default via 10.0.0.1 dev h3-eth0
# Configure h4
h4 ip addr add 10.0.0.3/24 dev h4-eth0
h4 ip link set h4-eth0 up
h4 ip route add default via 10.0.0.1 dev h4-eth0
# Configure r3
r3 ip addr add 10.0.0.1/24 dev r3-eth0
r3 ip addr add 1.0.2.2/30 dev r3-eth1
r3 ip addr add 1.0.3.2/30 dev r3-eth2
r3 ip link set r3-eth0 up
r3 ip link set r3-eth1 up
r3 ip link set r3-eth2 up
r3 ip route add 1.1.0.0/24 via 1.0.2.1
r3 ip route add 1.2.0.0/24 via 1.0.3.1
## Step 2
# Enable NAT on r3
r3 iptables -t nat -A POSTROUTING -o r3-eth1 -j MASQUERADE
# Allow traffic from r3-eth0 to r3-eth1 and r3-eth2
r3 iptables -A FORWARD -i r3-eth0 -o r3-eth1 -j ACCEPT
r3 iptables -A FORWARD -i r3-eth0 -o r3-eth2 -j ACCEPT
# Allow established returning traffic from r3-eth1 and r3-2th2 to r3-eth0
r3 iptables -A FORWARD -i r3-eth1 -o r3-eth0 -m state --state ESTABLISHED,RELATED -j ACCEPT
r3 iptables -A FORWARD -i r3-eth2 -o r3-eth0 -m state --state ESTABLISHED,RELATED -j ACCEPT
# Drop all other traffic
r3 iptables -A FORWARD -j DROP
