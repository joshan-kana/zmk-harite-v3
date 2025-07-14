#!/usr/bin/env bash
set -euo pipefail
source zephyr/zephyr-env.sh
west build -p always -s zmk/app -b seeeduino_xiao_ble -- -DSHIELD=settings_reset
