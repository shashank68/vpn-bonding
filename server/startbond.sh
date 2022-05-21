#!/bin/bash

# #############################################
#
# startbond.sh
#
# creates multiple tap devices
# and bonds them together
#
# #############################################
# set -x

# include the common settings
. /etc/openvpn/server/commonConfig

# load the required module

modprobe bonding

# create the bonding interface

ip link add $bondInterface type bond

# define the bonding mode
ip link set "$bondInterface" down
sleep 2
echo $bondingMode > /sys/class/net/${bondInterface}/bonding/mode

# now create the tap interfaces and enslave them to 
# the bond interface

for i in `seq 1 $numberOfTunnels`;
do
    openvpn --mktun --dev tap${i}
    ip link set tap${i} master $bondInterface
done

# then start the VPN connections

for i in `seq 1 $numberOfTunnels`;
do
    openvpn --config /etc/openvpn/server/server${i}.conf --daemon
done

# last but not least bring up the bonded interface

ip link set $bondInterface up mtu 1440


export OUR_WAN_INTERFACE=`ip route | grep default | sed s/.*dev\ //g | sed s/\ .*//g`
echo "WAN Interface is now: $OUR_WAN_INTERFACE"

sysctl -w net.ipv4.ip_forward=1

# now add the masquerading rules

iptables -A FORWARD -i "$bondInterface" -j ACCEPT
iptables -A FORWARD -o "$bondInterface" -j ACCEPT
iptables -t nat -A POSTROUTING -o $OUR_WAN_INTERFACE -j MASQUERADE

# now bring the bond interface up

ip link set "$bondInterface" up

# assign it the bondIP

ip addr add ${bondIP}/24 dev $bondInterface
