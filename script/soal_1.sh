# catatan penting
# eth1    10.80.1.1 (subnet 1)
# eth2    10.80.2.1 (subnet 2)
# eth3    10.80.3.1 (subnet 3)
# eth4    10.80.4.1 (subnet 4)
# eth5    10.80.5.1 (subnet 5)


# IP STATISSS
# ip client subnet 1
# Elendil     10.80.1.2
# Isildur     10.80.1.3
# Anarion     10.80.1.4
# Miriel      10.80.1.5
# Elros       10.80.1.6

# ip client subnet 2
# Galadriel   10.80.2.2
# Celeborn    10.80.2.3
# Oropher     10.80.2.4
# Celebrimbor 10.80.2.5
# Pharazon    10.80.2.6

# ip client subnet 3
# Erendis     10.80.3.2
# Amdir       10.80.3.3

# ip client subnet 4
# Aldarion    10.80.4.2
# Palantir    10.80.4.3
# Narvi       10.80.4.4

# ip client subnet 5
# Minastir    10.80.5.2

# IP DINAMISsSS
# Gilgalad    DHCP 
# Amandil     DHCP
# Khamul      DHCP (fixed address)
# Durin       (Router/DHCP Relay)


# di Durin
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



cat <<EOF > /root/.bashrc
apt-get update
apt-get install -y iptables
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
EOF


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

# config anarion (laravel worker-3)
auto eth0
iface eth0 inet static
    address 10.80.1.4
    netmask 255.255.255.0
    gateway 10.80.1.1
    up echo nameserver 192.168.122.1 > /etc/resolv.conf

# config miriel (client-static-1)
auto eth0
iface eth0 inet static
    address 10.80.1.5
    netmask 255.255.255.0
    gateway 10.80.1.1
    up echo nameserver 192.168.122.1 > /etc/resolv.conf

# config elros (load balancer (laravel))
auto eth0
iface eth0 inet static
    address 10.80.1.6
    netmask 255.255.255.0
    gateway 10.80.1.1
    up echo nameserver 192.168.122.1 > /etc/resolv.conf



# subnet 2 (gateway: 10.80.2.1)
# config galadriel (PHP worker-1)
auto eth0
iface eth0 inet static
    address 10.80.2.2
    netmask 255.255.255.0
    gateway 10.80.2.1
    up echo nameserver 192.168.122.1 > /etc/resolv.conf

# config celeborn (PHP worker-2)
auto eth0
iface eth0 inet static
    address 10.80.2.3
    netmask 255.255.255.0
    gateway 10.80.2.1
    up echo nameserver 192.168.122.1 > /etc/resolv.conf


# Oropher (PHP Worker-3)
auto eth0
iface eth0 inet static
    address 10.80.2.4
    netmask 255.255.255.0
    gateway 10.80.2.1
    up echo nameserver 192.168.122.1 > /etc/resolv.conf


# Celebrimbor (Client-Static-2)
cat <<EOF > /etc/network/interfaces
auto eth0
iface eth0 inet static
    address 10.80.2.5
    netmask 255.255.255.0
    gateway 10.80.2.1
    up echo nameserver 192.168.122.1 > /etc/resolv.conf
EOF

# Pharazon (Load Balancer (PHP))
cat <<EOF > /etc/network/interfaces
auto eth0
iface eth0 inet static
    address 10.80.2.6
    netmask 255.255.255.0
    gateway 10.80.2.1
    up echo nameserver 192.168.122.1 > /etc/resolv.conf
EOF

# Subnet 3 (Gateway: 10.80.3.1)

# Erendis (DNS Master)
cat <<EOF > /etc/network/interfaces
auto eth0
iface eth0 inet static
    address 10.80.3.2
    netmask 255.255.255.0
    gateway 10.80.3.1
    up echo nameserver 192.168.122.1 > /etc/resolv.conf
EOF

# Amdir (DNS Slave)
cat <<EOF > /etc/network/interfaces
auto eth0
iface eth0 inet static
    address 10.80.3.3
    netmask 255.255.255.0
    gateway 10.80.3.1
    up echo nameserver 192.168.122.1 > /etc/resolv.conf
EOF

# Subnet 4 (Gateway: 10.80.4.1)

# Aldarion (DHCP Server)
cat <<EOF > /etc/network/interfaces
auto eth0
iface eth0 inet static
    address 10.80.4.2
    netmask 255.255.255.0
    gateway 10.80.4.1
    up echo nameserver 192.168.122.1 > /etc/resolv.conf
EOF

# Palantir (Database Server)
cat <<EOF > /etc/network/interfaces
auto eth0
iface eth0 inet static
    address 10.80.4.3
    netmask 255.255.255.0
    gateway 10.80.4.1
    up echo nameserver 192.168.122.1 > /etc/resolv.conf
EOF

# Narvi (Database Slave)
cat <<EOF > /etc/network/interfaces
auto eth0
iface eth0 inet static
    address 10.80.4.4
    netmask 255.255.255.0
    gateway 10.80.4.1
    up echo nameserver 192.168.122.1 > /etc/resolv.conf
EOF

# Subnet 5 (Gateway: 10.80.5.1)

# Minastir (DNS FORWARDER)
cat <<EOF > /etc/network/interfaces
auto eth0
iface eth0 inet static
    address 10.80.5.2
    netmask 255.255.255.0
    gateway 10.80.5.1
    up echo nameserver 192.168.122.1 > /etc/resolv.conf
EOF

# Dinamis (kasih ip static sementara untuk client dinamis)
# Gilgalad (Client-Dynamic-1)
cat <<EOF > /etc/network/interfaces
auto eth0
iface eth0 inet static
    address 10.80.2.7
    netmask 255.255.255.0
    gateway 10.80.2.1
    up echo nameserver 192.168.122.1 > /etc/resolv.conf
EOF

# Amandil (Client-Dynamic-2)
cat <<EOF > /etc/network/interfaces
auto eth0
iface eth0 inet static
    address 10.80.1.7
    netmask 255.255.255.0
    gateway 10.80.1.1
    up echo nameserver 192.168.122.1 > /etc/resolv.conf
EOF

# Khamul (Client-Fixed-Address)
cat <<EOF > /etc/network/interfaces
auto eth0
iface eth0 inet static
    address 10.80.3.95
    netmask 255.255.255.0
    gateway 10.80.3.1
    up echo nameserver 192.168.122.1 > /etc/resolv.conf
EOF

# node statis seharusnya bisa melakukan ping
# node dinamis juga bisa, karena di set ke static dulu untuk sementara
ping google.com -c 4