# Harite v3 ZMK Firmware

- main/central half: left

![visual keymap](./harite_v3_keymap.svg)

## Using Pre-compiled Firmware

- Download the left/right uf2 files in the [Releases](https://github.com/dlip/zmk-harite-v3/releases)
- Plug the MCU into your USB port
- Press reset button on the MCU twice quickly
- Copy the respective sides' uf2 file onto the USB drive that appears
- Open [ZMK studio](https://zmk.studio)
- Press all 4 joysticks up on either hand to unlock it for keymap editing

## Building Your Own

- [Fork the repo](https://github.com/dlip/zmk-harite-v3/fork) then clone it
- Install [Python](https://www.python.org/downloads/)
- Install [West](https://docs.zephyrproject.org/latest/develop/west/install.html)
- Open terminal to cloned repo directory
- Init west

```
west init -l config
west update
```

- Set environment (Mac/Linux)

```
source zephyr/zephyr-env.sh
```

- Set environment (Windows)

```
zephyr/zephyr-env.cmd
```

- Build Left

```
west build -p auto -s zmk/app -S zmk-usb-logging -b seeeduino_xiao_ble -S studio-rpc-usb-uart -- -DSHIELD=harite_v3_left -DZMK_CONFIG=$PWD/config -DCONFIG_ZMK_STUDIO=y
```

- Put left side into bootloader mode and copy build/zephyr/zmk.uf2 to the usb drive

- Build Right

```
west build -p auto -s zmk/app -S zmk-usb-logging -b seeeduino_xiao_ble -S studio-rpc-usb-uart -- -DSHIELD=harite_v3_right -DZMK_CONFIG=$PWD/config -DCONFIG_ZMK_STUDIO=y
```

- Put right side into bootloader mode and copy build/zephyr/zmk.uf2 to the usb drive

## Building on Nix

### Immutably (bluetooth and full/partial wired works but zmk studio does not work)

- Build

```
nix -vL --show-trace build
```

- Flash the files in `result`

### Dev shell (all features work! however, only runs on linux as a test for python fails on darwin)

- Build

```
# enter nix dev shell
nix develop -c zsh

# setup west (only on first local build)
west init -l config
west update
west zephyr-export

# build firmware
scripts/build.sh (left/right)
```

- Put side into bootloader mode and copy build/zephyr/zmk.uf2 to the usb drive
