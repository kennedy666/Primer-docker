#!/bin/bash

LOG="/app/logs/monitor.log"
FECHA=$(date "+%F %T")

mkdir -p "$(dirname "$LOG")"

CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')
RAM_TOTAL=$(free -m | awk '/Mem:/ {print $2}')
RAM_USO=$(free -m | awk '/Mem:/ {print $3}')
RAM_PORC=$(awk "BEGIN {printf \"%.2f\", ($RAM_USO/$RAM_TOTAL)*100}")

echo "[$FECHA] 📊 CPU: ${CPU}% | RAM: ${RAM_USO}MB / ${RAM_TOTAL}MB (${RAM_PORC}%)" >> "$LOG"
