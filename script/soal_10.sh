# di elros (load balancer laravel)

# instal nginx
apt-get update
apt-get install -y nginx

# konfigurasi nginx sebagai reverse proxy
cat <<'EOF' > /etc/nginx/sites-available/load_balancer
log_format upstream_custom '\$remote_addr - \$remote_user [\$time_local] '
                             '"\$request" \$status \$body_bytes_sent '
                             '"\$http_referer" "\$http_user_agent" '
                             'upstream="\$upstream_addr"';


# definisikan grup worker (upstream)
upstream kesatria_numenor {
    # algoritma default adalah round robin (sesuai soal)
    server 10.80.1.2:8001; # elendil
    server 10.80.1.3:8002; # isildur
    server 10.80.1.4:8003; # anarion
}

server {
    listen 80;
    server_name elros.K33.com;

    access_log /var/log/nginx/elros_access.log upstream_custom;
    error_log /var/log/nginx/elros_error.log;

    location / {
        # teruskan semua request ke upstream
        proxy_pass http://kesatria_numenor;
        
        # (best practice) teruskan header info klien ke worker
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;

        proxy_http_version 1.1;
        proxy_set_header Connection "";

    }
}
EOF



cat > /etc/nginx/sites-available/load_balancer << 'EOF'
upstream kesatria_numenor {
    server 10.80.1.2:8001;  # Elendil
    server 10.80.1.3:8002;  # Isildur
    server 10.80.1.4:8003;  # Anarion
}

server {
    listen 80;
    server_name elros.K33.com;

    # Custom log format untuk tracking upstream
    log_format upstreamlog '$remote_addr - [$time_local] "$request" '
                          'upstream: $upstream_addr '
                          'status: $status '
                          'upstream_response_time: $upstream_response_time';
    
    # Terapkan log format baru ke file log spesifik
    access_log /var/log/nginx/elros_upstream.log upstreamlog;

    location / {
        proxy_pass http://kesatria_numenor;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
EOF

# aktifkan site baru
ln -s /etc/nginx/sites-available/load_balancer /etc/nginx/sites-enabled/

# hapus site default (penting agar tidak konflik)
rm /etc/nginx/sites-enabled/default

# restart nginx
service nginx restart

# test
# (jalankan dari node klien, contoh: miriel)

# 1. tes halaman utama
lynx http://elros.K33.com
# hasil yang diharapkan:
# anda akan melihat halaman laravel.
# (coba beberapa kali, beban harusnya berganti-ganti worker)

# 2. tes api
curl http://elros.K33.com/api/airing
# hasil yang diharapkan:
# anda akan melihat output JSON dari salah satu worker


for i in {1..12}; do
    echo "Request ke-$i:"
    curl -s http://elros.K33.com/api/airing | head -n 3
    echo "---"
done

cat /var/log/nginx/elros_access.log | grep "upstream" | sort | uniq -c
