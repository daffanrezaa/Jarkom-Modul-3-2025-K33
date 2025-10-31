# di aldarion (DHCP Server)
apt-get update
apt-get install -y isc-dhcp-server

# konfigurasi interface di /etc/default/isc-dhcp-server
cat <<EOF > /etc/default/isc-dhcp-server
INTERFACESv4="eth0"
INTERFACESv6=""
EOF

# Konfigurasi DHCP
cat <<EOF > /etc/dhcp/dhcpd.conf
authoritative;

# Subnet 1 - Client Dinamis Keluarga Manusia
subnet 10.80.1.0 netmask 255.255.255.0 {
    range 10.80.1.6 10.80.1.34;
    range 10.80.1.68 10.80.1.94;
    option routers 10.80.1.1;
    option broadcast-address 10.80.1.255;
    option domain-name-servers 192.168.122.1;
}

# Subnet 2 - Client Dinamis Keluarga Peri
subnet 10.80.2.0 netmask 255.255.255.0 {
    range 10.80.2.35 10.80.2.67;
    range 10.80.2.96 10.80.2.121;
    option routers 10.80.2.1;
    option broadcast-address 10.80.2.255; 
    option domain-name-servers 192.168.122.1;
}

# Subnet 3 - Area Khamul
subnet 10.80.3.0 netmask 255.255.255.0 {
    option routers 10.80.3.1;
    option broadcast-address 10.80.3.255;
}

# Subnet dimana Aldarion berada (sesuaikan!)
subnet 10.80.4.0 netmask 255.255.255.0 {
}

# Fixed Address untuk Khamul
host Khamul {
    hardware ethernet 02:42:4c:ce:39:00; 
    fixed-address 10.80.3.95;
}
EOF
# aa:bb:cc:dd ..., diisi dengan 
# mac address dengan ifconfig di Khamul

service isc-dhcp-server restart

# di Durin (DHCP Relay)
apt-get update
apt-get install -y isc-dhcp-relay


cat <<EOF > /etc/default/isc-dhcp-relay
SERVERS="10.80.4.2"
INTERFACES="eth1 eth2 eth3 eth4 eth5"
OPTIONS=""
EOF

cat <<EOF > /etc/sysctl.conf
net.ipv4.ip_forward=1
EOF

service isc-dhcp-relay restart

# ubah dari static ke dhcp
# di Gilgalad, Amandil, dan Khamul

# update config awal
cat <<EOF > /etc/network/interfaces
auto eth0
iface eth0 inet dhcp
EOF

# melepas statis dan meminta dhcp
ifdown eth0 && ifup eth0

# test
# di Khamul (fixed-address)
ip a
# harusnya 10.80.3.95

# di Amandil (dynamic-2)
ip a
# harus dalam range yang ada


