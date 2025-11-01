# masuk ke node clien (misal Miriel atau Celebrimbor)
# perinath ab
ab -n 100 -c 10 -A noldor:silvan http://pharazon.K33.com/

#Pantau Beban di Worker
#Buka tiga koneksi terminal SSH baru, satu untuk Galadriel, Celeborn, dan Oropher.
#Di setiap terminal worker tersebut, jalankan htop.

#Simulasi Kegagalan dan Tes Failover
# masuk ke galadriel dan matikan service nginx
service nginx stop

#Jalankan Ulang Benchmark dan kita liat apakah Pharazon menyadari hal ini.
#Kembali ke node client
#Jalankan perintah ab
ab -n 100 -c 10 -A noldor:silvan http://pharazon.K33.com/

# masuk ke pharazon
cat /var/log/nginx/error.log

# hidupkan kembali nginx di galadriel
service nginx start
