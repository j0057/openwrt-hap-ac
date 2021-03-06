# Fun with Mikrotik hAP AC

Better known as the [MikroTik RouterBOARD 962UiGS-5HacT2HnT][mikrotik-hap-ac].

## Basic procedure for installing OpenWRT

OpenWRT has documented some [common procedures][openwrt-rb-common-procedures]
for Mikrotik RouterBoard products. Basically, first you netboot an image over
TFTP and then you flash an image through the web interface or through SCP/SSH.

OpenWRT has documented the [hardware data][openwrt-hap-ac-hwdata].

Download URLs: [OpenWRT 18.06.4][openwrt-download-18-06-4].

## Howto

Download the flash images, they will be named
`openwrt-VERSION-ar71xx-mikrotik-rb-nor-flash-16M-ac-*.bin`. Specifically, you
can use `curl -O URL` to get them.

Then prepare for a netboot:

- Make sure no dhcpcd is running for net0!
- Set up an IP in 192.168.1.0/24 for net0: that is `ip link set dev net0 up`
  and `ip addr add dev net0 192.168.1.2/24`.
- The UTP cable should be connected to port 1, the upstream port.
- Run a DHCP/TFTP server. The script `netboot.sh` in this repo should do the
  trick. You want the `*-initramfs-kernel.bin` for the netboot.
- While pressing the reset button, power up the router. After aboot 15 seconds, it should be booted.
- *Switch the UTP cable to a LAN port such as port 2.*
- Use the IP that dnsmasq gave to the router to navigate to the web UI.
- Under System > Backup / Flash Firmware, upload the `*-squashfs-sysupgrade.bin` file.
  (This might be a good time to have been paranoid about checking the `sha256sum`s).
- The router will come up at [192.168.1.1](http://192.168.1.1/).

[mikrotik-hap-ac]: https://mikrotik.com/product/RB962UiGS-5HacT2HnT
[openwrt-rb-common-procedures]: https://openwrt.org/toh/mikrotik/common
[openwrt-hap-ac-hwdata]: https://openwrt.org/toh/hwdata/mikrotik/mikrotik_rb962uigs-5hact2hnt_hap_ac
[openwrt-download-18-06-4]: http://downloads.openwrt.org/releases/18.06.4/targets/ar71xx/mikrotik/
