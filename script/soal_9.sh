# di node klien (contoh: miriel)

# instal curl (lynx seharusnya sudah ada dari soal 7)
apt-get update
apt-get install -y curl

# test
# (jalankan dari miriel)

# --- Tes Elendil (Port 8001) ---

# tes 1: halaman utama laravel (dengan lynx)
lynx http://elendil.K33.com:8001
# hasil yang diharapkan:
# lynx akan menampilkan halaman web laravel (bukan 'welcome to nginx')

# tes 2: api (koneksi database)
curl http://elendil.K33.com:8001/api/airing
# hasil yang diharapkan:
# anda akan melihat output JSON yang berisi daftar data, contoh:
# {"data":[{"id":1,"title":"Judul Anime","status":"Airing",...}, ...]}

# --- Tes Isildur (Port 8002) ---

# tes 1: halaman utama laravel
lynx http://isildur.K33.com:8002

# tes 2: api (koneksi database)
curl http://isildur.K33.com:8002/api/airing
# hasil yang diharapkan:
# output JSON yang sama seperti elendil

# --- Tes Anarion (Port 8003) ---

# tes 1: halaman utama laravel
lynx http://anarion.K33.com:8003

# tes 2: api (koneksi database)
curl http://anarion.K33.com:8003/api/airing
# hasil yang diharapkan:
# output JSON yang sama seperti elendil

# --- Tes Tambahan (Soal 8: Blokir IP) ---

# tes 3: akses via ip (harus gagal)
curl http://10.80.1.2:8001
# hasil yang diharapkan:
# output '404 Not Found' (sesuai konfigurasi nginx kita)