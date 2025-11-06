# masuk ke pharazon
apt update && apt install nginx -y

# Konfigurasi Nginx sebagai Reverse Proxy
nano /etc/nginx/sites-available/default

# hapus semua dan ganti dengan ini
# Membuat upstream "Kesatria_Lorien" 
# Berisi IP dan Port unik dari setiap worker
cat << 'EOF' > /etc/nginx/sites-available/default
upstream Kesatria_Lorien {
    server 10.80.2.2:8004;
    server 10.80.2.3:8005;
    server 10.80.2.4:8006;
}

server {
    listen 80;
    server_name pharazon.K33.com;

    location / {
        proxy_pass http://Kesatria_Lorien;

        # Meneruskan header Basic Auth ke worker 
        proxy_set_header Authorization $http_authorization;
        proxy_pass_request_headers on;

        # Mengatur header IP Asli 
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
EOF

#di garadiel, celeborn, dan oropher
# tambahkan `Kesatria_Lorien` di server name masing masing setelah itu restart seperti biasa

#restart nginx
nginx -t
service nginx restart

# verifikasi dari klien
curl --user "noldor:silvan" http://pharazon.K33.com
