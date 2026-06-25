#!/bin/bash

CONF_FILE="$(dirname "$0")/sys_pulse.conf"

if [ ! -f "$CONF_FILE" ]; then
    echo "[ERROR] Configuration file $CONF_FILE not found!" >&2
    exit 1
fi

source "$CONF_FILE"

TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

CURRENT_CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}' | cut -d. -f1)
CURRENT_RAM=$(free | awk '/Mem:/ {printf "%.0f", $3/$2 * 100}')
CURRENT_DISK=$(df / | awk 'NR==2 {print 100 - $5}' | tr -d '%')

if [ ! -f "$METRICS_LOG" ]; then
    echo "Timestamp,CPU_Usage,RAM_Usage,Disk_Free" > "$METRICS_LOG"
fi

echo "${TIMESTAMP},${CURRENT_CPU},${CURRENT_RAM},${CURRENT_DISK}" >> "$METRICS_LOG"

touch "$ALERT_LOG"

# 1. ALERT: CPU > 80% for 5 minutes
if [ $(wc -l < "$METRICS_LOG") -ge 6 ]; then
    LAST_5_CPU=$(tail -n 5 "$METRICS_LOG" | cut -d, -f2)
    CPU_ALERT_TRIGGER=true
    
    for cpu in $LAST_5_CPU; do
        if [ "$cpu" -lt "$CPU_THRESHOLD" ]; then
            CPU_ALERT_TRIGGER=false
            break
        fi
    done

    if [ "$CPU_ALERT_TRIGGER" = true ]; then
        echo "[ALERT] [${TIMESTAMP}] CPU usage has been above ${CPU_THRESHOLD}% for the last 5 minutes!" >> "$ALERT_LOG"
    fi
fi

# 2. ALERT: Disk Free < 10%
if [ "$CURRENT_DISK" -lt "$DISK_MIN_FREE_PERCENT" ]; then
    echo "[ALERT] [${TIMESTAMP}] Critical storage level! Free disk space fell below ${DISK_MIN_FREE_PERCENT}% (Current: ${CURRENT_DISK}%)" >> "$ALERT_LOG"
fi

# 3. ALERT: Failed root logins
if [ -f "$AUTH_LOG_PATH" ]; then
    FAILED_ROOT_COUNT=$(grep -i "failed password for root" "$AUTH_LOG_PATH" | wc -l)
    
    if [ ! -f "$STATE_FILE" ]; then
        echo "0" > "$STATE_FILE"
    fi
    
    LAST_COUNT=$(cat "$STATE_FILE")
    
    if [ "$FAILED_ROOT_COUNT" -gt "$LAST_COUNT" ]; then
        NEW_ATTEMPTS=$((FAILED_ROOT_COUNT - LAST_COUNT))
        echo "[ALERT] [${TIMESTAMP}] Detected ${NEW_ATTEMPTS} new failed login attempts for user ROOT!" >> "$ALERT_LOG"
        echo "$FAILED_ROOT_COUNT" > "$STATE_FILE"
    fi
fi

# 4. ALERT: Network services status
for service in $CRITICAL_SERVICES; do
    systemctl is-active --quiet "$service"
    if [ $? -ne 0 ]; then
        echo "[ALERT] [${TIMESTAMP}] Critical service '${service}' is NOT responding/running!" >> "$ALERT_LOG"
    fi
done
