#!/bin/bash

./setup_topology.sh
cd server
ip netns e h2 ./install.sh
ip netns e h2 ./startbond.sh
cd ../client
ip netns e h1 ./install.sh
ip netns e h1 ./startbond.sh