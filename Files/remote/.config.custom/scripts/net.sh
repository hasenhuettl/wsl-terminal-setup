#!/bin/sh
# Usage: net.sh
# Execute this every x seconds to display network throughput across all interfaces in that second
# Very simplistic, calculation is off when script is run e.g. every 1.5 seconds

STAT_FILE="/tmp/net.prev"

get_totals() {
    awk '!/^ *lo:/ && /:/{rx+=$2; tx+=$10} END{print rx, tx}' /proc/net/dev
}

# Current counters
NOW=$(date +%s.%N)

read RX TX <<EOF
$(get_totals)
EOF

if [ -f "$STAT_FILE" ]; then
    read PREV_RX PREV_TX PREV_T < "$STAT_FILE"

    # Time difference (floating point, seconds)
    DELTA_T=$(echo "$NOW - $PREV_T" | bc -l)

    # Only compute if DELTA_T > 0 (check with 1 -eq "result", since bc boolean is inverted to UNIX boolean)
    if [ 1 -eq "$(echo "$DELTA_T > 0.001" | bc)" ]; then
        # Calculate RX/TX in Mbit/s (floating point)
        # - Take the difference in bytes (RX and TX).
        # - Convert bytes → bits (multiply by 8).
        # - Divide by elapsed seconds.
        # - Divide to convert bits → megabits
        # - Pipe to bc for floating point representation
        RX_RATE=$(echo "scale=2; ($RX - $PREV_RX) * 8 / $DELTA_T / 1000000" | bc -l)
        TX_RATE=$(echo "scale=2; ($TX - $PREV_TX) * 8 / $DELTA_T / 1000000" | bc -l)

        # Prevent negatives
        [ $(echo "$RX_RATE < 0" | bc) -eq 1 ] && RX_RATE=0
        [ $(echo "$TX_RATE < 0" | bc) -eq 1 ] && TX_RATE=0

        # Format output: set amount of decimal places (.xf); and leading 0 (%) if < 1
        RX_RATE=$(printf "%.0f" $RX_RATE)
        TX_RATE=$(printf "%.0f" $TX_RATE)

        # Output the throughput in MBit
        echo "↓${RX_RATE}MBit ↑${TX_RATE}MBit"
    else
        # Time difference is at or below 0, cannot compute
        echo "❓MBit ❓MBit"
    fi
else
    # Waiting for file creation
    echo "⏳MBit ⏳MBit"
fi

# Save current counters + precise timestamp
echo "$RX $TX $NOW" > "$STAT_FILE"

