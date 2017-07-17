#/bin/bash

# Always remove and refresh
[[ -d  /srv/docker/php-official/php ]] &&  \
  rm -rf /srv/docker/php-official/php

cd /srv/docker/php-official/
git clone https://github.com/docker-library/php.git
patch -p0 < php.patch

if [[ "$(docker images -q whw3/alpine 2> /dev/null)" == "" ]]; then
    if [[ ! -d /srv/docker/alpine ]]; then
        cd /srv/docker/
        git clone https://github.com/whw3/alpine.git
    fi
    cd /srv/docker/alpine
    git pull
    /srv/docker/alpine/build.sh
fi
cd /srv/docker/php-official/php/7.1/fpm/alpine/
grep PHP_VERSION Dockerfile| grep ENV| sed -e 's/ENV/export/;s/$/"/;s/VERSION /VERSION="/' > /srv/docker/php-official/PHP_VERSION
source /srv/docker/php-official/PHP_VERSION
RELEASE=$(echo $PHP_VERSION | sed 's/\.[0-9]\+$//')
cat << EOF > options 
export RELEASE="v$RELEASE"
export TAGS=(whw3/php:$RELEASE whw3/php:latest)
EOF

docker build -t whw3/php .
