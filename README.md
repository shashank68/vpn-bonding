# Linux Channel Bonding with VPN tunnel

## Dependencies

```bash
sudo apt install openvpn iperf3
```

## Usage

```bash
sudo ./start.sh
```

## Testing with iperf

- Server
```bash
sudo ip netns e h2 iperf3 -s
```

- Client
```bash
sudo ip netns e h1 iperf3 -c 10.8.0.254  -b 20mbit -u
```


## Topology

- Host `h1` with 2 interfaces is connected to switch `s`.
- `s` is connected to router `r`.
- `r` is connected to host `h2` (which hosts the openvpn server)
 
