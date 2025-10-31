# di Erendis (DNS Master)
# (Kita asumsikan bind9 sudah terinstal dari Soal 4)

# 1. MENIMPA Konfigurasi Zone di named.conf.local
#    Kita tambahkan zone reverse "3.80.10.in-addr.arpa"
#    untuk me-resolve IP 10.80.3.x
cat <<EOF >> /etc/bind/named.conf.local
zone "3.80.10.in-addr.arpa" {
    type master;
    file "/etc/bind/db.10.80.3";
    allow-transfer { 10.80.3.3; }; // Izinkan Amdir menyalin
};
EOF

# 2. MENIMPA File Zone "db.K33.com"
#    Kita tambahkan CNAME (www) dan TXT records
#    PENTING: Serial number dinaikkan dari 2 menjadi 3
cat <<EOF > /etc/bind/db.K33.com
\$TTL    604800
@       IN      SOA     ns1.K33.com. root.K33.com. (
                              3         ; Serial 
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
; Name Servers
@       IN      NS      ns1.K33.com.
@       IN      NS      ns2.K33.com.

; Name Server A Records
ns1     IN      A       10.80.3.2       ; Erendis
ns2     IN      A       10.80.3.3       ; Amdir

; Alias CNAME
www     IN      CNAME   K33.com.

; TXT Records
Elros     IN      TXT     "Cincin Sauron"
Pharazon  IN      TXT     "Aliansi Terakhir"
; -----------------------

; A Records 
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

# 3. MEMBUAT File Reverse Zone "db.10.80.3" (BARU)
#    Ini untuk memetakan IP ke nama (PTR Records)
cat <<EOF > /etc/bind/db.10.80.3
\$TTL    604800
@       IN      SOA     ns1.K33.com. root.K33.com. (
                              1         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      ns1.K33.com.
@       IN      NS      ns2.K33.com.

; PTR Records (dibalik)
2       IN      PTR     ns1.K33.com.    ; 10.80.3.2
3       IN      PTR     ns2.K33.com.    ; 10.80.3.3
EOF

service bind9 restart

# di Amdir (DNS Slave)
# (Kita asumsikan bind9 sudah terinstal dari Soal 4)

# 1. MENIMPA Konfigurasi Zone di named.conf.local
#    Kita tambahkan reverse zone "3.80.10.in-addr.arpa"
#    sebagai slave dari Erendis (10.80.3.2)
cat <<EOF >> /etc/bind/named.conf.local
zone "3.80.10.in-addr.arpa" {
    type slave;
    masters { 10.80.3.2; };
    file "/var/lib/bind/db.10.80.3";
};
EOF

service bind9 restart

# di Minastir (DNS Forwarder)
# (Kita asumsikan bind9 sudah terinstal dari Soal 3)

# 1. MENIMPA Konfigurasi Zone di named.conf.local
#    Kita tambahkan reverse zone "3.80.10.in-addr.arpa"
#    dan meneruskannya ke Erendis/Amdir
cat <<EOF >> /etc/bind/named.conf.local
zone "3.80.10.in-addr.arpa" {
    type forward;
    forward only;
    forwarders { 10.80.3.2; 10.80.3.3; };
};
EOF

service bind9 restart

# test
# (Harusnya dijalankan dari node KLIEN mana pun, statis atau dinamis)
# (Contoh: dari Miriel 10.80.1.5)

# 1. Tes CNAME
dig www.K33.com
# ... Di ANSWER SECTION, Anda akan melihat:
# ... www.K33.com.    ...  IN  CNAME   K33.com.
# ... K33.com.        ...  IN  A       ... (IP K33.com, jika ada)

# 2. Tes TXT Record
dig elros.K33.com TXT
# ... Di ANSWER SECTION, Anda akan melihat:
# ... elros.K33.com.  ...  IN  TXT     "Cincin Sauron"

dig pharazon.K33.com TXT
# ... Di ANSWER SECTION, Anda akan melihat:
# ... pharazon.K33.com. ...  IN  TXT     "Aliansi Terakhir"

# 3. Tes Reverse PTR
dig -x 10.80.3.2
# ... Di ANSWER SECTION, Anda akan melihat:
# ... 2.3.80.10.in-addr.arpa. ... IN PTR ns1.K33.com.