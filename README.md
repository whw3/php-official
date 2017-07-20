# php-official
Official PHP docker image adapted for use with Raspberry Pi

### Assumptions
* home for docker build images is ***/srv/docker***
* patch is installed on the host system

To build the docker image run ***/srv/docker/php-official/build.sh***
```
mkdir -p /srv/docker
cd /srv/docker
git clone https://github.com/whw3/php-official.git
cd php-official
chmod 0700 build.sh
./build.sh 
```
