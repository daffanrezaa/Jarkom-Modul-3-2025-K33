# di Erendis (DNS Master)
apt-get update
apt-get install -y bind9

ln -s /etc/init.d/named /etc/init.d/bind9

# Konfigurasi BIND9 untuk mendefinisikan Zone "K33.com"
# Kita beri tahu Erendis bahwa dia adalah "Master" untuk zone K33.com
# dan mengizinkan Amdir (10.80.3.3) untuk menyalin (transfer).
cat <<EOF > /etc/bind/named.conf.local
zone "K33.com" {
    type master;
    file "/etc/bind/db.K33.com";
    allow-transfer { 10.80.3.3; };
};
EOF

# Membuat "Peta" (Zone File) untuk K33.com
# Ini adalah file yang berisi semua data A record (IP address)
# hati hati kalo di root, cek lagi "\$"
cat <<EOF > /etc/bind/db.K33.com
\$TTL    604800
@       IN      SOA     ns1.K33.com. root.K33.com. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
; Name Servers
@       IN      NS      ns1.K3A3.com.
@       IN      NS      ns2.K33.com.

; Name Server A Records
ns1     IN      A       10.80.3.2       ; Erendis
ns2     IN      A       10.80.3.3       ; Amdir

; A Records untuk Lokasi Penting (Soal 4)
Palantir  IN      A       10.80.4.3
Elros     IN      A       10.80.1.6
Pharazon  IN      A       10.80.2.6
Elendil   IN      A       10.80.1.2
Isildur   IN      A       10.80.1.3
Anarion   IN      A       10.80.1.4
Galadriel IN      A       10.80.2.2
Celeborn  IN      A       10.80.2.3
Oropher   IN      A       10.80.2.4
EOF

service bind9 restart

# di Amdir (DNS Slave)
apt-get update
apt-get install -y bind9

ln -s /etc/init.d/named /etc/init.d/bind9

# Konfigurasi BIND9 untuk menjadi "Slave"
# Kita beri tahu Amdir untuk menyalin zone K33.com
# dari Master (10.80.3.2)
cat <<EOF > /etc/bind/named.conf.local
zone "K33.com" {
    type slave;
    masters { 10.80.3.2; };
    file "/var/lib/bind/db.K33.com";
};
EOF

service bind9 restart

# di Minastir (DNS Forwarder) -- UPDATE PENTING

# Kita harus memberi tahu Minastir (DNS utama kita)
# bahwa untuk domain "K33.com", dia harus bertanya ke
# Erendis & Amdir, BUKAN ke internet (192.168.122.1).
# Kita gunakan >> untuk MENAMBAHKAN, bukan menimpa.

cat <<EOF >> /etc/bind/named.conf.local

zone "K33.com" {
    type forward;
    forward only;
    forwarders { 10.80.3.2; 10.80.3.3; };
};
EOF

service bind9 restart

# test
# (Harusnya dijalankan dari node KLIEN mana pun, statis atau dinamis)
# (Contoh: dari Miriel 10.80.1.5)

# 1. Tes ping ke nama domain
ping elendil.K33.com -c 4
# ... Harusnya merespons dari 10.80.1.2

ping palantir.K33.com -c 4
# ... Harusnya merespons dari 10.80.4.3
