# Linux <-> Android Reverse Tethering Script
# This script tether the internet from your PC *to* the phone
# Some apps will not recognize the connection

echo "Enabling NAT on `hostname`..."
#enable IPV4 Forwarding.
sudo sysctl -w net.ipv4.ip_forward=1
#Flush the selected chain. deleting all the rules.
sudo iptables -t nat -F
#-A Append. -j Jump to the target. -o eth0 is Name  of an interface via which a packet is going to be sent.
#sudo iptables -t nat -A POSTROUTING -o wlan0 -j MASQUERADE
sudo iptables -t nat -A POSTROUTING -j MASQUERADE
#set DNS using 8.8.8.8 through udp.
#sudo iptables -t nat -A PREROUTING -i usb0 -p udp -m udp --dport 53 -j DNAT --to-destination 8.8.8.8:53
#get active interface
#● ip route get 1.1.1.1
#1.1.1.1 via 192.168.100.1 dev eth0  src 192.168.100.7
#● ip route
#default via 192.168.100.1 dev eth0  proto static

echo "Connecting to the phone via 'adb ppp'..."
/usr/bin/adb ppp "shell:pppd nodetach noauth noipdefault defaultroute /dev/tty" nodetach noauth noipdefault notty 10.0.0.1:10.0.0.2

echo "Done."
