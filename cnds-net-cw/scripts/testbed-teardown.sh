#!/bin/bash

set -xe

rm_bridge () {
  if ip link show $1 &> /dev/null; then
    ip link set dev $1 down
    brctl delbr $1
  fi
}

#rm_pair () {
#  if ip link show $1 &> /dev/null; then
#    ip link delete $1 type veth
#  fi
#}

rm_ns () {
  if [ -e "/var/run/netns/$1" ]; then
    ip netns delete $1
  fi
}

rm_ns r1
rm_ns r2
rm_ns r3
rm_ns h1
rm_ns h2
rm_ns h3
rm_ns h4

rm_bridge br1
rm_bridge br2
rm_bridge br3
