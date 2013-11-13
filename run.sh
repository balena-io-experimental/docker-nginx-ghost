#!/bin/bash

/usr/local/bin/init.sh

/etc/init.d/nginx restart

cd /ghost && npm start
