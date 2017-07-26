#/bin/bash

# Always remove and refresh
[[ -d  /srv/docker/php-official/php ]] &&  \
  rm -rf /srv/docker/php-official/php

cd /srv/docker/php-official/
git clone https://github.com/docker-library/php.git
#patch -p0 < php.patch
cd ./php
find . -name Dockerfile| xargs sed -i 's_FROM alpine:[0-9.]\+_FROM whw3/alpine:latest_;s_FROM debian:jessie_FROM whw3/rpi-s6_'
find . -name Dockerfile| xargs sed -i 's/ha.pool.sks-keyservers.net/ipv4.pool.sks-keyservers.net/'
find . -name Dockerfile| xargs sed -i 's_ENTRYPOINT \["docker-php-entrypoint"\]_ENTRYPOINT \["/init"\]_'


TAGS=( $(grep -R "FROM whw" --include 'Dockerfile'|grep -v "zts"| cut -d: -f1| sort | awk '!/^ / && NF {print $1 " . off"}') )
whiptail --title "Build Menu" --checklist --separate-output "Select " 18 48 12 "${TAGS[@]}" 2>BUILDLIST
while read ITEM
do
    cd /srv/docker/php-official/php
    WORKDIR=$(echo "$ITEM" | sed 's:/Dockerfile::');
    RELEASE=$(echo "$WORKDIR"|cut -d/ -f1)
    TAG=$(echo "$WORKDIR" | sed 's:'$RELEASE'::;s:/:-:g');
    [[ "$TAG" = "" ]] && TAG="-cli"
    echo "Buildiing ..."
    cd $WORKDIR
    grep PHP_VERSION Dockerfile| grep ENV| sed -e 's/ENV/export/;s/$/"/;s/VERSION /VERSION="/' > PHP_VERSION
    source PHP_VERSION
    cat << EOF > options
export RELEASE="v$RELEASE"
export TAGS=(whw3/php:$PHP_VERSION$TAG whw3/php:$RELEASE$TAG)
EOF
    cat options
    docker build -t whw3/php:$PHP_VERSION$TAG .
    docker tag whw3/php:$PHP_VERSION$TAG whw3/php:$RELEASE$TAG

done < BUILDLIST
exit
