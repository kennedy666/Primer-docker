#!/bin/bash

LOG="/app/logs/actualizacion.log"
FECHA=$(date "+%F %T")

mkdir -p "$(dirname "$LOG")"

echo "[$FECHA] 🔄 Iniciando simulación de actualización..." >> "$LOG"

apt-get update >> "$LOG" 2>&1
apt-get upgrade --simulate >> "$LOG" 2>&1

echo "[$FECHA] ✅ Simulación completada" >> "$LOG"
echo "------------------------------" >> "$LOG"

# Enviar resumen por correo
echo -e "To: mario.villaverdebaron6@gmail.com
Subject: 🔄 Simulación de actualización completada
From: mario.villaverdebaron6@gmail.com

Se ejecutó una simulación de actualización del sistema a las $FECHA.

Consulta el log completo en:
$LOG
" | msmtp --from=default -t
