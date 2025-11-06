#masuk ke pharazon 
nano /etc/nginx/nginx.conf

#Di dalam blok http { ... } (di bawah limit_req_zone)
proxy_cache_path /var/cache/nginx levels=1:2 keys_zone=php_cache:10m max_size=1g inactive=60m;

#Terapkan Cache ke Situs
#Edit file konfigurasi situs Pharazon
nano /etc/nginx/sites-available/default

#Di dalam blok location / { ... }, tambahkan beberapa baris proxy_cache
# Terapkan zona cache 'php_cache'
proxy_cache php_cache;

#Tentukan apa yang di-cache (kode 200) dan berapa lama
proxy_cache_valid 200 1m; 

# KUNCI UNTUK VERIFIKASI:
# Tambahkan header kustom untuk melihat status HIT/MISS
add_header X-Proxy-Cache $upstream_cache_status;

#Buat Direktori Cache
mkdir -p /var/cache/nginx

#restart nginx
nginx -t
service nginx restart

#Verifikasi Cache 
# masuk ke node clien jalankan permintaan pertama
curl -I --user "noldor:silvan" http://pharazon.K33.com

# jalankan permintaan kedua
curl -I --user "noldor:silvan" http://pharazon.K33.com

