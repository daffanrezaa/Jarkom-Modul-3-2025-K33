# masuk ke galadriel 
apt update && apt install apache2-utils -y

#di galadriel 
htpasswd -cb /etc/nginx/.htpasswd noldor silvan

# Modifikasi Konfigurasi Nginx di galadriel
nano /etc/nginx/sites-available/default

# TAMBAHKAN DUA BARIS INI di server req ke domain sebelum location 404
auth_basic "Area Terlarang Noldor & Silvan";
auth_basic_user_file /etc/nginx/.htpasswd;

# restart nginx
nginx -t
service nginx restart
service php8.4-fpm restart 

# ULANGI LANGKAH LANGKAH DI ATAS DI CELEBORN DAN OROPHER

# verifikasi dari klien
# Tes Gagal (Tanpa Otentikasi)
curl http://galadriel.K33.com:8004/


# Tes Berhasil (Dengan Otentikasi)
curl --user "noldor:silvan" http://galadriel.K33.com:8004/

lynx http://galadriel.K33.com:8004