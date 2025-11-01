# masuk ke galadriel 
apt update && apt install apache2-utils -y

#di galadriel 
htpasswd -cb /etc/nginx/.htpasswd noldor silvan

# Modifikasi Konfigurasi Nginx di galadriel
nano /etc/nginx/sites-available/default

# TAMBAHKAN DUA BARIS INI di server req ke domain tambah langsung di root
auth_basic "Area Terlarang Noldor & Silvan";
auth_basic_user_file /etc/nginx/.htpasswd;

# restart nginx
nginx -t
service nginx restart

# ULANGI LANGKAH LANGKAH DI ATAS DI CELEBORN DAN OROPHER

# verifikasi dari klien
# Tes Gagal (Tanpa Otentikasi)
curl http://10.80.2.2:8004


# Tes Berhasil (Dengan Otentikasi)
curl --user "noldor:silvan" http://10.80.2.2:8004

lynx http://galadriel.K33.com:8004