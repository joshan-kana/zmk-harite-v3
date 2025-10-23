#!/usr/bin/env bash
set -euo pipefail
west init -l config
west update
west zephyr-export