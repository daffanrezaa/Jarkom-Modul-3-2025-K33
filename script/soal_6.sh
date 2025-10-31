# di Aldarion (DHCP Server)
# konfigurasi DHCP, tambahkan lease time
cat <<EOF > /etc/dhcp/dhcpd.conf
authoritative;
option domain-name-servers 10.80.5.2;

# subnet 1 - Client Dinamis Keluarga Manusia
subnet 10.80.1.0 netmask 255.255.255.0 {
    range 10.80.1.6 10.80.1.34;
    range 10.80.1.68 10.80.1.94;
    option routers 10.80.1.1;
    option broadcast-address 10.80.1.255;

    default-lease-time 1800;    # 30 menit
    max-lease-time 3600;        # 1 jam
}

# subnet 2 - Client Dinamis Keluarga Peri
subnet 10.80.2.0 netmask 255.255.255.0 {
    range 10.80.2.35 10.80.2.67;
    range 10.80.2.96 10.80.2.121;
    option routers 10.80.2.1;
    option broadcast-address 10.80.2.255; 

    default-lease-time 600;    # 10 menit
    max-lease-time 3600;       # 1 jam
}

# subnet 3 - Area Khamul
subnet 10.80.3.0 netmask 255.255.255.0 {
    option routers 10.80.3.1;
    option broadcast-address 10.80.3.255;

    default-lease-time 1800;    # 30 menit
    max-lease-time 3600;        # 1 jam
}

# subnet 4 
subnet 10.80.4.0 netmask 255.255.255.0 {
}

# Fixed Address untuk Khamul
host Khamul {
    hardware ethernet 02:42:4c:ce:39:00; 
    fixed-address 10.80.3.95;
}
EOF

# restart service 
service isc-dhcp-server restart

# restart client khamul amandil dan gilgalad lewat gns

# test di Aldarion
cat /var/lib/dhcp/dhcpd.leases
# akan ada beberapa blok lease, cek punya amandil dan gilgalad