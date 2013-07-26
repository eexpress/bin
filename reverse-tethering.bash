# Linux <-> Android Reverse Tethering Script
# This script tether the internet from your PC *to* the phone
# Some apps will not recognize the connection

echo "Enabling NAT on `hostname`..."
sudo sysctl -w net.ipv4.ip_forward=1
sudo iptables -t nat -F
sudo iptables -t nat -A POSTROUTING -j MASQUERADE

echo "Connecting to the phone via 'adb ppp'..."
/usr/bin/adb ppp "shell:pppd nodetach noauth noipdefault defaultroute /dev/tty" nodetach noauth noipdefault notty 10.0.0.1:10.0.0.2

echo "Done."