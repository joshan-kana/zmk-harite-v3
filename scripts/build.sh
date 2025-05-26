#!/usr/bin/env bash
set -euo pipefail
source zephyr/zephyr-env.sh
west build -p -s zmk/app -b seeeduino_xiao_ble -S zmk-usb-logging -- -DSHIELD=harite_v3_left -DZMK_CONFIG=$PWD/config
