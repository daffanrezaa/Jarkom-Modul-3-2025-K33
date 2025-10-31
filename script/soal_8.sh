# di palantir (database server)

# instal mariaDB server
apt-get update
apt-get install -y mariadb-server

# konfigurasi agar bisa diakses dari node lain (worker)
# kita edit file 50-server.cnf untuk mengubah 'bind-address'
# '127.0.0.1' (hanya localhost) -> '0.0.0.0' (semua interface)
sed -i "s/bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/" /etc/mysql/mariadb.conf.d/50-server.cnf

service mariadb restart

# setup database dan user
# (ganti 'PasswordRahasia' dengan password anda)
# kita izinkan akses dari '10.80.1.%' (subnet 1 tempat worker berada)
mysql -u root <<EOF
CREATE DATABASE laravel_db;
CREATE USER 'laravel_user'@'10.80.1.%' IDENTIFIED BY 'JarkomSuram';
GRANT ALL PRIVILEGES ON laravel_db.* TO 'laravel_user'@'10.80.1.%';
FLUSH PRIVILEGES;
EOF

# di elendil (worker 1 - port 8001)

# konfigurasi koneksi database .env
# (asumsi code di /var/www/laravel dari soal 7)
# (ganti 'PasswordRahasia' dengan password yang anda buat di palantir)
cd /var/www/laravel
sed -i "s/DB_HOST=127.0.0.1/DB_HOST=10.80.4.3/" .env
sed -i "s/DB_DATABASE=laravel/DB_DATABASE=laravel_db/" .env
sed -i "s/DB_USERNAME=root/DB_USERNAME=laravel_user/" .env
sed -i "s/DB_PASSWORD=/DB_PASSWORD=JarkomSuram/" .env

# konfigurasi nginx untuk port 8001
# kita buat file konfigurasi baru
cat <<EOF > /etc/nginx/sites-available/laravel
server {
    listen 8001;
    server_name elendil.K33.com;

    root /var/www/laravel/public;
    index index.php index.html;

    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php8.4-fpm.sock;
    }
}

# server block untuk menolak akses via ip (soal 8)
server {
    listen 8001 default_server;
    server_name _;
    return 404; # atau 403
}
EOF

# aktifkan site dan hapus link default

rm /etc/nginx/sites-enabled/default

service nginx restart

# jalankan migrasi dan seeding (hanya di elendil)
php artisan migrate --seed

# di isildur (worker 2 - port 8002)

# konfigurasi koneksi database .env
# (ganti 'PasswordRahasia')
cd /var/www/laravel
sed -i "s/DB_HOST=127.0.0.1/DB_HOST=10.80.4.3/" .env
sed -i "s/DB_DATABASE=laravel/DB_DATABASE=laravel_db/" .env
sed -i "s/DB_USERNAME=root/DB_USERNAME=laravel_user/" .env
sed -i "s/DB_PASSWORD=/DB_PASSWORD=JarkomSuram/" .env

# konfigurasi nginx untuk port 8002
cat <<EOF > /etc/nginx/sites-available/laravel
server {
    listen 8002;
    server_name isildur.K33.com;

    root /var/www/laravel/public;
    index index.php index.html;

    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php8.4-fpm.sock;
    }
}

# server block untuk menolak akses via ip
server {
    listen 8002 default_server;
    server_name _;
    return 404;
}
EOF

# aktifkan site dan hapus link default
ln -s /etc/nginx/sites-available/laravel /etc/nginx/sites-enabled/
rm /etc/nginx/sites-enabled/default

php artisan key:generate
service nginx restart

# di anarion (worker 3 - port 8003)

# konfigurasi koneksi database .env
# (ganti 'PasswordRahasia')
cd /var/www/laravel
sed -i "s/DB_HOST=127.0.0.1/DB_HOST=10.80.4.3/" .env
sed -i "s/DB_DATABASE=laravel/DB_DATABASE=laravel_db/" .env
sed -i "s/DB_USERNAME=root/DB_USERNAME=laravel_user/" .env
sed -i "s/DB_PASSWORD=/DB_PASSWORD=JarkomSuram/" .env

# konfigurasi nginx untuk port 8003
cat <<EOF > /etc/nginx/sites-available/laravel
server {
    listen 8003;
    server_name anarion.K33.com;

    root /var/www/laravel/public;
    index index.php index.html;

    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php8.4-fpm.sock;
    }
}

# server block untuk menolak akses via ip
server {
    listen 8003 default_server;
    server_name _;
    return 404;
}
EOF

# aktifkan site dan hapus link default
ln -s /etc/nginx/sites-available/laravel /etc/nginx/sites-enabled/
rm /etc/nginx/sites-enabled/default

php artisan key:generate
service nginx restart