#!/bin/bash

cd /etc/nginx/sites-enabled && rm -f default

cd /etc/nginx/sites-available && cat << EOF > ghost
server {
    listen 0.0.0.0:80;
    server_name ghost;
    access_log /var/log/nginx/ghost.log;

    location / {
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header HOST \$http_host;
        proxy_set_header X-NginX-Proxy true;

        proxy_pass http://127.0.0.1:2368;
        proxy_redirect off;
    }
}
EOF

cd /etc/nginx/sites-enabled && ln -sf ../sites-available/ghost ghost

sed -i "s,^/usr/local/bin/init.sh,#/usr/local/bin/init.sh," /usr/local/bin/run.sh
