#!/bin/bash -ex

if ! type -p dnsmasq > /dev/null; then
    echo "going to need dnsmasq for this" 2>/dev/null
    exit 1
fi

if [ $(id -u) != 0 ]; then
    echo "going to need root for this!" 2>/dev/null
    exit 1
fi

dnsmasq \
    --interface=net0 \
    --dhcp-range=192.168.1.100,192.168.1.200 \
    --dhcp-boot=${1:?please specify the initramfs file} \
    --enable-tftp \
    --tftp-root=$(pwd) \
    --no-daemon \
    --user=$USER \
    --edns-packet-max=0 \
    --dhcp-authoritative \
    --log-dhcp \
    --bootp-dynamic \
    --log-queries
