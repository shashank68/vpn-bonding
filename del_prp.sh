#!/bin/bash
set -x

# kill $(ip netns pids h1)
# kill $(ip netns pids h2)
# kill $(ip netns pids r)
killall openvpn

ip netns del h1
ip netns del h2
ip netns del r
ip netns del s