#!/system/bin/busyboxx sh
insmod /opt/etc/wireguard/wireguard.ko
ip link add dev wg0 type wireguard
ip address add dev wg0 10.0.0.8/32
ip link set up mtu 1500 dev wg0
/opt/bin/wg set wg0 private-key /opt/etc/wireguard/privatekey peer LR4RMQADUG+yikA+S6/CV1HcxI/utTUVdFRcyGFEmjc= allowed-ips 0.0.0.0/0 endpoint 92.125.172.50:25138 persistent-keepalive 25
sleep 15
ip route add 10.0.0.0/24 dev wg0
ip route add 0.0.0.0/1 via 10.0.0.1 dev wg0
ip route add 128.0.0.0/1 via 10.0.0.1 dev wg0
sleep 3
/system/bin/iptables -t nat -I POSTROUTING -o wg0 -j MASQUERADE
sleep 3
/system/bin/ebtables -t nat -D PREROUTING -p IPv4 --logical-in br0 --mark 0x0/0xff000000 -j mark --mark-or 0x10000000 --mark-target ACCEPT
