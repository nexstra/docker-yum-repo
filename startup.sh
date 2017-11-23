#!/bin/bash

mkdir /logs/repo-scanner
mkdir /logs/nginx
mkdir /logs/supervisord

chown nginx:nginx /logs/nginx
for d in $(find /repo -type d  ) ; do
    if  ls $d/*.rpm >/dev/null ; then 
        createrepo  --update $d
    fi
done
    

exec /usr/bin/supervisord -n -c /etc/supervisord.conf
