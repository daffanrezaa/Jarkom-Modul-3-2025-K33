# di Elendil, Isildur, DAN Anarion (Worker Laravel)

# Instalasi semua tools
apt-get update
apt-get install -y nginx git composer \
                   php8.4-fpm php8.4-mysql php8.4-mbstring \
                   php8.4-xml php8.4-curl php8.4-zip

# Dapatkan "Cetak Biru" (Source Code Laravel)
git clone https://github.com/elshiraphine/laravel-simple-rest-api /var/www/laravel

# Pindah ke direktori Laravel
cd /var/www/laravel

# Instal dependensi Laravel

composer install
composer update 

# Siapkan file environment
cp .env.example .env

# Generate kunci aplikasi Laravel
php artisan key:generate

# Atur izin folder
chown -R www-data:www-data /var/www/laravel/storage /var/www/laravel/bootstrap/cache
chmod -R 775 /var/www/laravel/storage /var/www/laravel/bootstrap/cache

# Jalankan service
service php8.4-fpm start
service nginx start

# di node Klien (Contoh: Miriel)

# Instal lynx
apt-get update
apt-get install -y lynx

# test
# (Jalankan dari Miriel)
# Cek Elendil
lynx http://elendil.K33.com
# Cek Isildur
lynx http://isildur.K33.com
# Cek Anarion
lynx http://anarion.K33.com

# Hasil yang diharapkan:
# Ketiganya akan menampilkan halaman default "Welcome to nginx!"
# Ini membuktikan Nginx jalan dan DNS (Soal 4/5) berfungsi.