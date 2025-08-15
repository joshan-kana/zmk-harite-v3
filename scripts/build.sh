#!/usr/bin/env bash
set -euo pipefail
source zephyr/zephyr-env.sh
KEYMAP=${1}
SIDE=${2}
rm -f config/harite_v3.keymap
ln -s "harite_v3_${KEYMAP}.keymap" config/harite_v3.keymap
west build -p auto -s zmk/app -S zmk-usb-logging -b seeeduino_xiao_ble -S studio-rpc-usb-uart -- -DSHIELD=harite_v3_${SIDE} -DZMK_CONFIG=$PWD/config -DCONFIG_ZMK_STUDIO=y
