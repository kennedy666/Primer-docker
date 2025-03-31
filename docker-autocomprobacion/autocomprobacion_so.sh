#!/bin/bash

LOG="/app/logs/autocomprobacion.log"
FECHA=$(date "+%F %T")

mkdir -p "$(dirname "$LOG")"

echo "[$FECHA] 🔎 Autocomprobación del sistema:" >> "$LOG"

# Verificar servicios básicos
for SERVICE in cron ssh; do
  if systemctl is-active --quiet $SERVICE; then
    echo " ✅ Servicio $SERVICE activo" >> "$LOG"
  else
    echo " ❌ Servicio $SERVICE INACTIVO" >> "$LOG"
  fi
done

# Verificar uso de disco
DISCO=$(df -h / | awk 'NR==2 {print $5}')
echo " 💾 Uso del disco en /: $DISCO" >> "$LOG"

# Verificar permisos
for DIR in /app /tmp; do
  if [ -w "$DIR" ]; then
    echo " ✅ Permisos de escritura OK en $DIR" >> "$LOG"
  else
    echo " ❌ Sin permisos de escritura en $DIR" >> "$LOG"
  fi
done

echo "------------------------------" >> "$LOG"
