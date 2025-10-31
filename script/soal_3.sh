# di Minastir (DNS Forwarder)
apt-get update
apt-get install -y bind9

ln -s /etc/init.d/named /etc/init.d/bind9

# Konfigurasi BIND9 sebagai Forwarder
cat <<EOF > /etc/bind/named.conf.options
options {
    directory "/var/cache/bind";

    // Izinkan query dari jaringan internal kita (10.80.x.x)
    allow-query { 10.80.0.0/16; localhost; localnets; };
    
    // Izinkan recursi (forwarding) untuk jaringan internal kita
    allow-recursion { 10.80.0.0/16; localhost; localnets; };

    // Forward semua request ke DNS GNS3
    forwarders {
        192.168.122.1;
    };
    forward only; // Hanya forward, jangan coba resolve sendiri

    dnssec-validation auto;
    listen-on-v6 { any; };
};
EOF

service bind9 restart

# di Aldarion (UPDATE DHCP Server)

# Kita harus MENGGANTI DNS server yang dibagikan ke klien.
# Sebelumnya: 192.168.122.1
# Sekarang: 10.80.5.2 (IP Minastir)

cat <<EOF > /etc/dhcp/dhcpd.conf
# Opsi global
authoritative;
option domain-name-servers 10.80.5.2;

# subnet 1 - Client Dinamis Keluarga Manusia
subnet 10.80.1.0 netmask 255.255.255.0 {
    range 10.80.1.6 10.80.1.34;
    range 10.80.1.68 10.80.1.94;
    option routers 10.80.1.1;
    option broadcast-address 10.80.1.255;
}

# subnet 2 - Client Dinamis Keluarga Peri
subnet 10.80.2.0 netmask 255.255.255.0 {
    range 10.80.2.35 10.80.2.67;
    range 10.80.2.96 10.80.2.121;
    option routers 10.80.2.1;
    option broadcast-address 10.80.2.255; 
}

# subnet 3 - Area Khamul
subnet 10.80.3.0 netmask 255.255.255.0 {
    option routers 10.80.3.1;
    option broadcast-address 10.80.3.255;
    # Baris DNS dipindah ke global
}

# subnet 4 - (Wajib ada agar service jalan)
subnet 10.80.4.0 netmask 255.255.255.0 {
}

# Fixed Address untuk Khamul (MAC Address dari log Anda)
host Khamul {
    hardware ethernet 02:42:4c:ce:39:00; 
    fixed-address 10.80.3.95;
}
EOF

service isc-dhcp-server restart

# restart node di Gilgalad, Amandil, dan Khamul 

# Ganti nameserver semua client statis
echo "nameserver 10.80.5.2" > /etc/resolv.conf

# testing
# di node statis
dig google.com
# harusnya servernya bakal ke forward ke 10.80.5.2  

# di node dinamis
cat /etc/resolv.conf
dig google.com
# harusnya servernya bakal ke forward ke 10.80.5.2  