#Definisikan Zona Rate Limit
# di elros 
nano /etc/nginx/nginx.conf

#Di dalam blok http { ... }
limit_req_zone $binary_remote_addr zone=per_ip:10m rate=10r/s;

#Terapkan Zona ke Situs
# di elros
nano /etc/nginx/sites-available/load_balancer

#Di dalam blok location / { ... }, tambahkan baris limit_req
limit_req zone=per_ip burst=20;

#restart nginx
nginx -t
service nginx restart

#ULANGI LANGKAH DI ATAS DI PAHRAZON

#verifikasi 
# di elros uji lebih dari 10 request per detik
ab -n 100 -c 50 http://elros.K33.com/api/airing/

#uji di pahrazon
ab -n 100 -c 50 -A noldor:silvan http://pharazon.K33.com/

# masuk ke elros untuk memeriksa log
cat /var/log/nginx/error.log

# ulagi ke pharazon untuk memeriksa log
 

