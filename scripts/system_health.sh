#!/usr/bin/env bash
#
# system_health.sh
# Appends timestamped CPU / Memory / Disk metrics to health_log.txt
# Warns when disk usage exceeds 80%.

set -euo pipefail

LOG_FILE="$(dirname "$0")/health_log.txt"
DISK_THRESHOLD=80

# ── Collect metrics ────────────────────────────────────────────
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# CPU usage (%): 100 - idle
CPU_USAGE=$(top -bn1 | awk '/^%Cpu/ {print 100 - $8}' | cut -d. -f1)

# Memory usage (%): used / total * 100
MEM_USAGE=$(free | awk '/^Mem:/ {printf "%.0f", $3/$2 * 100}')

# Disk usage (%): root filesystem
DISK_USAGE=$(df / | awk 'NR==2 {gsub("%","",$5); print $5}')

# ── Write to log ──────────────────────────────────────────────
LINE="[$TIMESTAMP] CPU: ${CPU_USAGE}% | MEM: ${MEM_USAGE}% | DISK: ${DISK_USAGE}%"
echo "$LINE" | tee -a "$LOG_FILE"

# ── Threshold check ───────────────────────────────────────────
if [ "$DISK_USAGE" -gt "$DISK_THRESHOLD" ]; then
    WARNING="[WARNING] Disk space high! Current usage: ${DISK_USAGE}%"
    echo "$WARNING" | tee -a "$LOG_FILE"
    exit 1
fi

exit 0
