# di durin
# config NAT1
auto eth0
iface eth0 inet dhcp

# config Switch1 
auto eth1
iface eth1 inet static
    address 10.80.1.1
    netmask 255.255.255.0

# config Switch2
auto eth2
iface eth2 inet static
    address 10.80.2.1
    netmask 255.255.255.0

# config Switch3 
auto eth3
iface eth3 inet static
    address 10.80.3.1
    netmask 255.255.255.0

# config Switch4
auto eth4
iface eth4 inet static
    address 10.80.4.1
    netmask 255.255.255.0

# config Minastir
auto eth5
iface eth5 inet static
    address 10.80.5.1
    netmask 255.255.255.0


apt-get update && apt-get install -y iptables
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

# di masing masing client
# subnet 1 (gateway 10.80.1.1)
# config elendil -> (laravel worker-1)
auto eth0
iface eth0 inet static
    address 10.80.1.2
    netmask 255.255.255.0
    gateway 10.80.1.1
    up echo nameserver 192.168.122.1 > /etc/resolv.conf

# config isildur -> (laravel worker-2)
auto eth0
iface eth0 inet static
    address 10.80.1.3
    netmask 255.255.255.0
    gateway 10.80.1.1
    up echo nameserver 192.168.122.1 > /etc/resolv.conf

# config anarion -> (laravel worker-3)
auto eth0
iface eth0 inet static
    address 10.80.1.4
    netmask 255.255.255.0
    gateway 10.80.1.1
    up echo nameserver 192.168.122.1 > /etc/resolv.conf

# config miriel -> (client-static-1)
auto eth0
iface eth0 inet static
    address 10.80.1.5
    netmask 255.255.255.0
    gateway 10.80.1.1
    up echo nameserver 192.168.122.1 > /etc/resolv.conf

# config elros -> (load balancer (laravel))
auto eth0
iface eth0 inet static
    address 10.80.1.6
    netmask 255.255.255.0
    gateway 10.80.1.1
    up echo nameserver 192.168.122.1 > /etc/resolv.conf



# subnet 2 (gateway: 10.80.2.1)
# config galadriel -> (PHP worker-1)
auto eth0
iface eth0 inet static
    address 10.80.2.2
    netmask 255.255.255.0
    gateway 10.80.2.1
    up echo nameserver 192.168.122.1 > /etc/resolv.conf

# config celeborn -> (PHP worker-2)
auto eth0
iface eth0 inet static
    address 10.80.2.3
    netmask 255.255.255.0
    gateway 10.80.2.1
    up echo nameserver 192.168.122.1 > /etc/resolv.conf

# config oropher -> (PHP Worker-3)
auto eth0
iface eth0 inet static
    address 10.80.2.4
    netmask 255.255.255.0
    gateway 10.80.2.1
    up echo nameserver 192.168.122.1 > /etc/resolv.conf

# config celebrimbor -> (Client-Static-2)
auto eth0
iface eth0 inet static
    address 10.80.2.5
    netmask 255.255.255.0
    gateway 10.80.2.1
    up echo nameserver 192.168.122.1 > /etc/resolv.conf

# config pharazon -> (Load Balancer (PHP))
auto eth0
iface eth0 inet static
    address 10.80.2.6
    netmask 255.255.255.0
    gateway 10.80.2.1
    up echo nameserver 192.168.122.1 > /etc/resolv.conf


# Subnet 3 (Gateway: 10.80.3.1)
# config erendis -> (DNS Master)
auto eth0
iface eth0 inet static
    address 10.80.3.2
    netmask 255.255.255.0
    gateway 10.80.3.1
    up echo nameserver 192.168.122.1 > /etc/resolv.conf

# config amdir -> (DNS Slave)
auto eth0
iface eth0 inet static
    address 10.80.3.3
    netmask 255.255.255.0
    gateway 10.80.3.1
    up echo nameserver 192.168.122.1 > /etc/resolv.conf


# Subnet 4 (Gateway: 10.80.4.1)
# config aldarion -> (DHCP Server)
auto eth0
iface eth0 inet static
    address 10.80.4.2
    netmask 255.255.255.0
    gateway 10.80.4.1
    up echo nameserver 192.168.122.1 > /etc/resolv.conf

# config palantir -> (Database Server)
auto eth0
iface eth0 inet static
    address 10.80.4.3
    netmask 255.255.255.0
    gateway 10.80.4.1
    up echo nameserver 192.168.122.1 > /etc/resolv.conf

# config narvi -> (Database Slave)
auto eth0
iface eth0 inet static
    address 10.80.4.4
    netmask 255.255.255.0
    gateway 10.80.4.1
    up echo nameserver 192.168.122.1 > /etc/resolv.conf


# Subnet 5 (Gateway: 10.80.5.1)
# config minastir -> (DNS Forwarder)
auto eth0
iface eth0 inet static
    address 10.80.5.2
    netmask 255.255.255.0
    gateway 10.80.5.1
    up echo nameserver 192.168.122.1 > /etc/resolv.conf

# congig gilgalad -> (Client Dinamis 1)
auto eth0
iface eth0 inet static
    address 10.80.2.7
    netmask 255.255.255.0
    gateway 10.80.2.1
    up echo nameserver 192.168.122.1 > /etc/resolv.conf

# config amandil (Client Dinamis 2)
auto eth0
iface eth0 inet static
    address 10.80.1.7
    netmask 255.255.255.0
    gateway 10.80.1.1
    up echo nameserver 192.168.122.1 > /etc/resolv.conf

# cinfig khamul -> (Client Fixed Address)
auto eth0
iface eth0 inet static
    address 10.80.3.95
    netmask 255.255.255.0
    gateway 10.80.3.1
    up echo nameserver 192.168.122.1 > /etc/resolv.conf



# catatan penting
# subnet 1    10.80.1.1 
# subnet 2    10.80.2.1 
# subnet 3    10.80.3.1 
# subnet 4    10.80.4.1 
# subnet 5    10.80.5.1 


# IP STATISSS
# ip client subnet 1
# elendil     10.80.1.2
# isildur     10.80.1.3
# anarion     10.80.1.4
# miriel      10.80.1.5
# elros       10.80.1.6


# ip client subnet 2
# galadriel   10.80.2.2
# celeborn    10.80.2.3
# oropher     10.80.2.4
# celebrimbor 10.80.2.5
# pharazon    10.80.2.6


# ip client subnet 3
# erendis     10.80.3.2
# amdir       10.80.3.3


# ip client subnet 4
# aldarion    10.80.4.2
# palantir    10.80.4.3
# narvi       10.80.4.4


# ip client subnet 5
# minastir    10.80.5.2


# IP DINAMISsSS
# gilgalad    DHCP client
# amandil     DHCP client
# khamul      DHCP (fixed address client)
# durin       (Router/DHCP Relay)