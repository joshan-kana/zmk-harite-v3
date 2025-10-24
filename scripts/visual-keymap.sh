#/usr/bin/env bash

# parse keymap
keymap parse -z ./config/harite_v3.keymap > config/harite_v3_keymap.yaml

# draw keymap
keymap draw --dts-layout=config/boards/shields/harite_v3/harite_v3-layouts.dtsi config/harite_v3_keymap.yaml > harite_v3_keymap.svg

# visual keymap created!
echo "Visual keymap created! ⌨️"