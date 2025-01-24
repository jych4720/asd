#!/bin/bash

set -xe
shopt -s expand_aliases

. alias.sh

create_bridge () {
  if ! ip link show $1 &> /dev/null; then
    brctl addbr $1
    ip link set dev $1 up
  fi
}

create_ns () {
  if [ ! -e "/var/run/netns/$1" ]; then
    ip netns add $1
  fi
}

connect_routers () {
    ip link add name $3 type veth peer name $4

    ip link set $3 netns $1
    ip netns exec $1 ip link set dev $3 up

    ip link set $4 netns $2
    ip netns exec $2 ip link set dev $4 up
}

connect_to_bridge () {
  ip link add name $3 type veth peer name $4
  brctl addif $2 $4
  ip link set dev $4 up

  ip link set $3 netns $1
  ip netns exec $1 ip link set dev $3 up
}

create_ns r1
create_ns r2
create_ns r3
create_ns h1
create_ns h2
create_ns h3
create_ns h4

# Create the triangle router connections
connect_routers r1 r2 r1-eth1 r2-eth1
connect_routers r1 r3 r1-eth2 r3-eth1
connect_routers r2 r3 r2-eth2 r3-eth2

create_bridge br1
create_bridge br2
create_bridge br3

# Connect br1
connect_to_bridge h1 br1 h1-eth0 br1-eth0
connect_to_bridge r1 br1 r1-eth0 br1-eth1

# Connect br2
connect_to_bridge h2 br2 h2-eth0 br2-eth0
connect_to_bridge r2 br2 r2-eth0 br2-eth1

# Connect br3
connect_to_bridge h3 br3 h3-eth0 br3-eth0
connect_to_bridge h4 br3 h4-eth0 br3-eth1
connect_to_bridge r3 br3 r3-eth0 br3-eth2

r1 sysctl -w net.ipv4.ip_forward=1
r2 sysctl -w net.ipv4.ip_forward=1
r3 sysctl -w net.ipv4.ip_forward=1
