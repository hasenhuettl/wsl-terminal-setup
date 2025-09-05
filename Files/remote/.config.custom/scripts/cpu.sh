#!/bin/sh
# Usage: cpu.sh
# Waits 1 second, then displays cpu usage in that second

STAT_FILE="/tmp/cpu.prev"

# Current CPU line
CURR=$(grep '^cpu ' /proc/stat)

CURR_IDLE=$(echo "$CURR" | awk '{print $5}')
CURR_TOTAL=$(echo "$CURR" | awk '{sum=0; for(i=2;i<=8;i++) sum+=$i; print sum}')

if [ -f "$STAT_FILE" ]; then
    PREV=$(cat "$STAT_FILE")
    PREV_IDLE=$(echo "$PREV" | awk '{print $5}')
    PREV_TOTAL=$(echo "$PREV" | awk '{sum=0; for(i=2;i<=8;i++) sum+=$i; print sum}')

    DIFF_IDLE=$((CURR_IDLE - PREV_IDLE))
    DIFF_TOTAL=$((CURR_TOTAL - PREV_TOTAL))

    if [ "$DIFF_TOTAL" -gt 0 ]; then
        DIFF_USAGE=$((100 * (DIFF_TOTAL - DIFF_IDLE) / DIFF_TOTAL))
    else
        DIFF_USAGE=0
    fi
    echo "${DIFF_USAGE}%"
else
    echo "0%"
fi

echo "$CURR" > "$STAT_FILE"

