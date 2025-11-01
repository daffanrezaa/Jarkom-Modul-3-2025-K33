#Setup Worker PHP (Galadriel, Celeborn, Oropher)

#Login ke Galadriel (ulangi nanti di Celeborn dan Oropher).
# buat skirp di root 
# nano /root/.bashrc

# taruh di /root/.bashrc semua worker
echo "--- Memulai instalasi Nginx dan PHP-FPM ---"
apt-get update
apt-get install nginx php8.4-fpm -y

echo "--- Membuat file index.php ---"
# Membuat direktori web
mkdir -p /var/www/html

# Menulis konten PHP ke file 
echo "<?php echo 'Selamat datang di taman Peri ' . gethostname(); ?>" > /var/www/html/index.php

# Memberikan kepemilikan ke user web server (www-data)
chown -R www-data:www-data /var/www/html

echo "--- Instalasi selesai ---"

#jalankan script 
bash /root/.bashrc

#Konfigurasi Nginx (Domain-Only, Port Unik, Socket PHP)
# masuk ke galadriel dan edit 
nano /etc/nginx/sites-available/default

# ganti semua dengan ini 
# Server block ini akan menangkap semua request ke port 8004 yang BUKAN domain 'galadriel.K33.com'.
cat <<EOF > /etc/nginx/sites-available/default
server {
    # Mendengarkan di port 8004 
    listen 8004 default_server;

    # 'server_name _' menangkap semua host yang tidak cocok
    server_name _;

    # Tolak semua atau kembalikan 404
    return 404;
}

# Server block ini hanya akan merespon request ke domain 'galadriel.K33.com'
server {
    # Mendengarkan di port 8004 
    listen 8004;

    server_name galadriel.K33.com;

    root /var/www/html;
    index index.php;

    location / {
        try_files $uri $uri/ =404;
    }

    # meneruskan request .php ke socket PHP-FPM 
    location ~ \.php$ {
        include snippets/fastcgi-php.conf;

        # Pastikan path socket ini benar
        fastcgi_pass unix:/run/php/php8.4-fpm.sock;
    }
}
EOF

#Ulangi Langkah 2 di node lain tapi dengan 
# di celeborn 
cat <<EOF > /etc/nginx/sites-available/default
server {
    # Mendengarkan di port 8005 
    listen 8005 default_server;

    # 'server_name _' menangkap semua host yang tidak cocok
    server_name _;

    # Tolak semua atau kembalikan 404
    return 404;
}

# Server block ini hanya akan merespon request ke domain 'celeborn.K33.com'
server {
    # Mendengarkan di port 8004 
    listen 8005;

    server_name celeborn.K33.com;

    root /var/www/html;
    index index.php;

    location / {
        try_files $uri $uri/ =404;
    }

    # meneruskan request .php ke socket PHP-FPM 
    location ~ \.php$ {
        include snippets/fastcgi-php.conf;

        # Pastikan path socket benar
        fastcgi_pass unix:/run/php/php8.4-fpm.sock;
    }
}
EOF

# di oropher
cat <<EOF > /etc/nginx/sites-available/default
server {
    # Mendengarkan di port 8006 
    listen 8006 default_server;

    # menangkap semua host yang tidak cocok
    server_name _;

    # Tolak semua atau kembalikan 404
    return 404;
}

# Server block ini hanya akan merespon request ke domain 'oropher.K33.com'
server {
    # Mendengarkan di port 8004 
    listen 8006;

    server_name oropher.K33.com;

    root /var/www/html;
    index index.php;

    location / {
        try_files $uri $uri/ =404;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;

        # Pastikan path socket ini benar
        fastcgi_pass unix:/run/php/php8.4-fpm.sock;
    }
}
EOF

# restart nginx
nginx -t
service nginx restart
service php8.4-fpm restart 

#verifikasi dari klien
# tes akses ip 
curl http://10.80.2.2:8004

# tes akses domain
lynx http://galadriel.K33.com:8004