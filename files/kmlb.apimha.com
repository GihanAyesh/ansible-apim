server {
        listen *:443 ssl;
        listen [::]:443 ssl;

        ssl_certificate     /etc/ssl/nginx/nginx-repo.crt;
        ssl_certificate_key /etc/ssl/nginx/nginx-repo.key;
        ssl_ciphers         EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH;
        ssl_protocols       TLSv1.1 TLSv1.2;

        root /var/www/html;

        # Add index.php to the list if you are using PHP
        index index.html index.htm index.nginx-debian.html;
        proxy_set_header X-Forwarded-Port 443;
        ssl on;

        server_name kmlb.apimha.com;

        location / {
                proxy_set_header X-Forwarded-Host $host;
                proxy_set_header X-Forwarded-Server $host;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header Host $http_host;
                proxy_read_timeout 5m;
                proxy_send_timeout 5m;
                proxy_pass https://km.apimha.com;
        }
}

