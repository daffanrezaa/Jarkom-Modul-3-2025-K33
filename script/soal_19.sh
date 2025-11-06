#Definisikan Zona Rate Limit
# di elros 
nano /etc/nginx/nginx.conf

# tambahkan di dalam blok http
http {
    # ... (pengaturan http lainnya) ...

    # 1. Definisi log format dari Soal 10
    log_format upstream_custom '$remote_addr - $remote_user [$time_local] '
                             '"$request" $status $body_bytes_sent '
                             '"$http_referer" "$http_user_agent" '
                             'upstream="$upstream_addr"';

    # 2. Definisi zona limit dari Soal 19
    limit_req_zone $binary_remote_addr zone=per_ip:10m rate=10r/s;

    # ... (baris include sites-enabled) ...
}

#Terapkan Zona ke Situs
# di elros
nano /etc/nginx/sites-available/load_balancer

#Di dalam blok location / { ... }, tambahkan baris limit_req
upstream kesatria_numenor {
    # ... (konfigurasi weight Anda dari Soal 11) ...
}

server {
    listen 80;
    server_name elros.K33.com;

    access_log /var/log/nginx/elros_upstream.log upstream_custom;
    
    # Pastikan 'warn' ada di sini
    error_log /var/log/nginx/elros_error.log warn;

    location / {
        # ... (semua proxy_set_header Anda) ...

        # Terapkan zona limit
        limit_req zone=per_ip burst=20;
    }
}

#restart nginx
nginx -t
service nginx restart

# DI PAHRAZON
nano /etc/nginx/nginx.conf

#Tambahkan limit_req_zone di dalam blok http { ... }:
http {
    # ... (pengaturan http lainnya) ...

    # Definisi zona limit dari Soal 19
    limit_req_zone $binary_remote_addr zone=per_ip:10m rate=10r/s;

    # ... (baris include sites-enabled) ...
}

# kemudian masuk ke konfigurasi nginx pharazon
nano /etc/nginx/sites-available/default

#Tambahkan error_log dan limit_req
upstream Kesatria_Lorien {
    # ... (konfigurasi upstream Anda dari Soal 16) ...
}

server {
    listen 80;
    server_name pharazon.K33.com;

    # Tambahkan baris ini untuk mencatat 'warn'
    error_log /var/log/nginx/pharazon_error.log warn;

    location / {
        # ... (semua proxy_set_header Anda dari Soal 16) ...

        # Terapkan zona limit
        limit_req zone=per_ip burst=20;
    }
}

# restart nginx
nginx -t
service nginx restart

#verifikasi di klien
# di elros uji lebih dari 10 request per detik
ab -n 100 -c 50 http://elros.K33.com/api/airing/

#uji di pahrazon
ab -n 100 -c 50 -A noldor:silvan http://pharazon.K33.com/

# masuk ke elros untuk memeriksa log
cat /var/log/nginx/elros_error.log

# ulagi ke pharazon untuk memeriksa log
cat /var/log/nginx/pharazon_error.log

