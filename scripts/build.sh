#!/usr/bin/env bash
set -euo pipefail
source zephyr/zephyr-env.sh
if [ -z "${1:-}" ]; then
  echo "Error: build.sh <side(left/right)>"
fi

# if build directory exists, remove it (otherwise the previous side's firmware will not be overwritten)
if [ -d build ]; then
  rm -rf build
fi

SIDE=${1}

# set the number of parallel threads
export CMAKE_BUILD_PARALLEL_LEVEL=$(nproc)
west build -p auto -s zmk/app -S zmk-usb-logging -b seeeduino_xiao_ble -S studio-rpc-usb-uart -- -DSHIELD=harite_v3_${SIDE} -DZMK_CONFIG=$PWD/config -DCONFIG_ZMK_STUDIO=y
