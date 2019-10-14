#!/bin/bash

downloads='https://downloads.openwrt.org'
gpg_key_id='0xCD84BCED626471F1'

# find latest version
echo ">>> GET $downloads/"
targets="$(curl -s $downloads/ | ./pup 'a json{}' | jq -r '.[0].href')/ar71xx/mikrotik"

# find images, check if they already exist and then download them
echo ">>> GET $downloads/$targets/"
curl -s "$downloads/$targets/" \
    | ./pup 'a json{}' \
    | jq -r '.[].href' \
    | { while read filename; do
            if ! [[ $filename =~ ^openwrt-[0-9]+\.[0-9]+\.[0-9]+-ar71xx-mikrotik-rb-nor-flash-16M-ac-.*\.bin$ ]]; then
                continue ;
            fi ;
            if [ ! -f "$filename" ]; then
                echo ">>> GET $filename" ;
                curl $downloads/$targets/$filename -o $filename ;
                echo ;
            fi ;
        done ; }

# get sha256sums
curl -s $downloads/$targets/sha256sums -O
curl -s $downloads/$targets/sha256sums.asc -O

# check existence of key
if ! gpg --list-keys "$gpg_key_id" &>/dev/null; then
    echo "ERROR: missing key $gpg_key_id"
    exit 1
fi

# check signature
if ! gpg --verify sha256sums.asc sha256sums; then
    echo "ERROR: wrong signature on sha256sum file"
    exit 1
fi

# check sha256sums
if !  sha256sum --check --ignore-missing --quiet sha256sums; then
    echo "ERROR: corrupt files detected"
    exit 1
fi
