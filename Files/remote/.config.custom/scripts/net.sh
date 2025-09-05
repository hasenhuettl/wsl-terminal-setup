#!/bin/sh
# Usage: net.sh
# Waits 1 second, then displays network throughput across all interfaces in that second

STAT_FILE="/tmp/net.prev"

get_totals() {
    awk '!/^ *lo:/ && /:/{rx+=$2; tx+=$10} END{print rx, tx}' /proc/net/dev
}

# Current counters
NOW=$(date +%s)

read RX TX <<EOF
$(get_totals)
EOF

if [ -f "$STAT_FILE" ]; then
    read PREV_RX PREV_TX PREV_T < "$STAT_FILE"
    DELTA_T=$((NOW - PREV_T))
    if [ "$DELTA_T" -gt 0 ]; then
        RX_RATE=$(( (RX - PREV_RX) / 1024 / DELTA_T ))
        TX_RATE=$(( (TX - PREV_TX) / 1024 / DELTA_T ))
        [ "$RX_RATE" -lt 0 ] && RX_RATE=0
        [ "$TX_RATE" -lt 0 ] && TX_RATE=0
        echo "↓${RX_RATE}K ↑${TX_RATE}K"
    else
        echo "Time missmatch! ${NOW} is less than ${PREV_T}!"
    fi
else
    echo "↓0K ↑0K"
fi

echo "$RX $TX $NOW" > "$STAT_FILE"

