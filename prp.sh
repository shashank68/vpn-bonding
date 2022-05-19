#!/bin/bash
set -x
shopt -s expand_aliases


alias netex="ip netns exec"

function set_veth_netns {
    ip link set $1 netns $2
    netex $2 ip link set $1 up
    netex $2 ip addr add $3 dev $1
}

function set_veth_switch {
    ip link set $1 netns $2
    netex $2 ip link set $1 master $2
    netex $2 ip link set dev $1 up
}

ip netns add h1
netex h1 ip link set lo up

ip netns add h2
netex h2 ip link set lo up

ip netns add s
netex s ip link set dev lo up
netex s ip link add s type bridge
netex s ip link set dev s up

ip netns add r
netex r ip link set lo up
netex r sysctl -w net.ipv4.ip_forward=1

ip link add h1_s_a type veth peer name s_h1_a
ip link add h1_s_b type veth peer name s_h1_b

ip link add s_r type veth peer name r_s
# swtich to 
ip link add h2_r type veth peer name r_h2

set_veth_switch s_h1_a s
set_veth_netns h1_s_a h1 11.0.0.2/24

set_veth_switch s_h1_b s
set_veth_netns h1_s_b h1 11.0.0.3/24

set_veth_switch s_r s
set_veth_netns r_s r 11.0.0.1/24

set_veth_netns r_h2 r 12.0.0.1/24
set_veth_netns h2_r h2 12.0.0.2/24

netex h1 ip route add default dev h1_s_a via 11.0.0.1
netex h1 ip route add default dev h1_s_b via 11.0.0.1

netex h2 ip route add default dev h2_r via 12.0.0.1


# tc -n s qdisc add dev s_h1_a root netem rate 10mbit
# tc -n s qdisc add dev s_h1_b root netem rate 5mbit

# ip link set h1_r_a netns h1
# netex h1 ip link set h1_r_a up

# ip link set h1_r_b netns h1
# netex h1 ip link set h1_r_b up

# ip link set h2_r_a netns h2
# netex h2 ip link set h2_r_a up

# ip link set h2_r_b netns h2
# netex h2 ip link set h2_r_b up

# ip link set r_h1_a netns r
# netex r ip link set r_h1_a up

# ip link set r_h1_b netns r
# netex r ip link set r_h1_b up

# ip link set r_h2_a netns r
# netex r ip link set r_h2_a up

# ip link set r_h2_b netns r
# netex r ip link set r_h2_b up



