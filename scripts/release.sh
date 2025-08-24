#!/usr/bin/env bash
set -euo pipefail

rm -rf release
mkdir release
sides=(left right)
for side in "${sides[@]}"; do
  echo "Processing: $side"
  scripts/build.sh ${side}
  cp build/zephyr/zmk.uf2 release/default_${side}.uf2
done

scripts/reset.sh
cp build/zephyr/zmk.uf2 release/reset.uf2
rm -rf build
