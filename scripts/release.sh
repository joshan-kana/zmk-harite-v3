#!/usr/bin/env bash
set -euo pipefail

rm -rf release
mkdir release
keymaps=(default stained)
sides=(left right)
for keymap in "${keymaps[@]}"; do
  for side in "${sides[@]}"; do
    echo "Processing: $keymap $side"
    scripts/build.sh ${keymap} ${side}
    cp build/zephyr/zmk.uf2 release/${keymap}_${side}.uf2
  done
done

scripts/reset.sh
cp build/zephyr/zmk.uf2 release/reset.uf2
rm -rf build
