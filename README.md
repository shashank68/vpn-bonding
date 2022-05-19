# Openvpn tunneling with Linux bonding

## Usage Steps


```bash
sudo apt install openvpn
```

```bash
./start.sh
```

## Topology

- Host `h1` with 2 interfaces is connected to switch `s`.
- `s` is connected to router `r`.
- `r` is connected to host `h2` (which acts as the openvpn server)
 
