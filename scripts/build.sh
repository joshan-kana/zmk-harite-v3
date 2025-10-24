#!/usr/bin/env bash
set -euo pipefail
source zephyr/zephyr-env.sh

# Function to build a single side
build_side() {
  local side=$1
  local build_dir="build_${side}"
  
  # rm -rf "${build_dir}"
  
  west build -d "${build_dir}" -p auto -s zmk/app -S zmk-usb-logging -b seeeduino_xiao_ble -S studio-rpc-usb-uart -- -DSHIELD=harite_v3_${side} -DZMK_CONFIG=$PWD/config -DCONFIG_ZMK_STUDIO=y
}

if [ -n "${1:-}" ]; then
  # Single side build: use all cores
  export CMAKE_BUILD_PARALLEL_LEVEL=$(nproc)
  # Build single side
  build_side "$1"
else
  # Parallel build: split cores between sides
  export CMAKE_BUILD_PARALLEL_LEVEL=$(($(nproc)/2))
  # Build both sides in parallel
  build_side "left" &
  build_side "right" &
  wait
fi
