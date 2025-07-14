#!/usr/bin/env bash
set -euo pipefail
source zephyr/zephyr-env.sh
SIDE=${1:-left}
west build -p always -s zmk/app -b seeeduino_xiao_ble -S zmk-usb-logging -S studio-rpc-usb-uart -- -DSHIELD=harite_v3_${SIDE} -DZMK_CONFIG=$PWD/config -DCONFIG_ZMK_STUDIO=y
