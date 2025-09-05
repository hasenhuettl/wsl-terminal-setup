#!/bin/sh
# Usage: mem.sh
# Prints memory usage percentage

free -m | awk '/Mem:/ {printf "%d%%", $3/$2*100}'

