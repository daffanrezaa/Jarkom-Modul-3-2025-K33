# masuk ke galadriel dan edit
nano /var/www/html/index.php

# hapus konten lama dan ganti dengan ini
<?php
echo 'Selamat datang di taman Peri ' . gethostname() . '<br><br>';

#Menampilkan IP yang dilihat langsung oleh server (akan menjadi IP Pharazon)
echo 'IP Pengunjung (REMOTE_ADDR): ' . $_SERVER['REMOTE_ADDR'] . '<br>';

#Memeriksa apakah header X-Real-IP (IP Asli) dikirim oleh proxy
if (isset($_SERVER['HTTP_X_REAL_IP'])) {
    echo 'Alamat IP pengunjung ASLI (X-Real-IP): ' . $_SERVER['HTTP_X_REAL_IP'];
} else {
    echo 'Alamat IP pengunjung ASLI (X-Real-IP): (Tidak terdeteksi)';
}
?>

# Modifikasi Konfigurasi Nginx Worker
nano /etc/nginx/sites-available/default


}# cari blok location / dan tambahkan dengan ini
location ~ \.php$ {
    include snippets/fastcgi-php.conf;
    fastcgi_pass unix:/run/php/php8.4-fpm.sock;

    # TAMBAHKAN BARIS INI
    # Baris ini mengambil header 'X-Real-IP' dari request
    # (variabel: $http_x_real_ip) dan meneruskannya ke PHP
    fastcgi_param X-Real-IP $http_x_real_ip;

# restart nginx
nginx -t
service nginx restart   
service php8.4-fpm restart

# ULANGI LANGKAH DI ATAS DI CELEBORN DAN OROPHER

# test awal 
# Tes langsung ke Galadriel
curl --user "noldor:silvan" http://galadriel.K33.com:8004