#!/bin/sh
set -e

if [ -f /etc/nginx/sites-enabled/default ]; then
	rm -f /etc/nginx/sites-enabled/default
fi

if [ ! -f /etc/nginx/sites-available/ghost ]; then
	cd /etc/nginx/sites-available && cat << EOF > ghost
server {
    listen 0.0.0.0:80;
    server_name ghost;
    access_log /var/log/nginx/ghost.log;

    location / {
        rewrite ^ $URL\$request_uri? permanent;
    }

    location ^~ /blog {
        rewrite  ^/blog/(.*)  /\$1 break;

        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header HOST \$http_host;
        proxy_set_header X-NginX-Proxy true;

        proxy_pass http://127.0.0.1:2368;
        proxy_redirect off;
    }

    location ~ /(.+)$ {
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header HOST \$http_host;
        proxy_set_header X-NginX-Proxy true;

        proxy_pass http://127.0.0.1:2368;
        proxy_redirect off;
    }
}
EOF
fi

cd /etc/nginx/sites-enabled && ln -sf ../sites-available/ghost ghost

if [ -f /ghost/config.example.js ] && [ ! -f /ghost/config.js ]; then
	cd /ghost && cp config.example.js config.js
fi
sed -i -e "s,http://my-ghost-blog.com,$URL/blog,g" /ghost/config.js

service nginx start

cd /ghost

if [ ! -d /ghost/node_modules ]; then
	cd /ghost && npm install --production
fi

npm start
