# pada salah satu klien (misal Miriel atau Celebrimbor)
apt update && apt install apache2-utils -y

# lakukan serangan awal 
ab -n 100 -c 10 http://elros.K33.com/api/airing

# Buka tiga koneksi terminal SSH baru, satu untuk masing-masing worker: Elendil, Isildur, dan Anarion.
# Di setiap terminal worker tersebut, jalankan htop. untuk melihat penggunaan CPU dan memori secara real-time.

#lakukan serangan penuh 
ab -n 2000 -c 100 http://elros.K33.com/api/airing

# Analisis saat tes berjalan
# kembali ke terminal worker (Elendil, Isildur, dan Anarion) dan amati penggunaan CPU dan memori pada htop.

# setelah benchmark selesai pindah ke elros untuk memeriksa apakah Elros mencatat adanya masalah.
cat /var/log/nginx/error.log

#strategi bertahan
# masuk ke erlos kemudian edit konfigurasi nginx dan temukan upstream kesatria_numenor
nano /etc/nginx/sites-available/load_balancer

# tambahkan weight
upstream kesatria_numenor {
    server 10.80.1.2:8001 weight=3; 
    server 10.80.1.3:8002 weight=1;
    server 10.80.1.4:8003 weight=1;
}

# restart nginx
nginx -t
service nginx restart

# ulangi serangan penuh dan pantau hasilnya 
