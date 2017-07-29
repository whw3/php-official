#!/bin/sed -f
s_FROM alpine:[0-9.]\+_FROM whw3/alpine_
s_FROM debian:jessie_FROM whw3/rpi-s6_
s/ha.pool.sks-keyservers.net/ipv4.pool.sks-keyservers.net/
s_ENTRYPOINT \["docker-php-entrypoint"\]_ENTRYPOINT \["/init"\]_