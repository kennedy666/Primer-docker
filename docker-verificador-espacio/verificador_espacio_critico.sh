#!/bin/bash

LOG="/app/logs/espacio.log"
FECHA=$(date "+%F %T")
CRITICO=85

mkdir -p "$(dirname "$LOG")"

echo "[$FECHA] 🧪 Verificando espacio en disco..." >> "$LOG"

ALERTA=""

df -h | grep '^/dev/' | while read line; do
  USO=$(echo $line | awk '{print $5}' | tr -d '%')
  PUNTO=$(echo $line | awk '{print $6}')
  if [ "$USO" -ge "$CRITICO" ]; then
    MENSAJE="⚠️ Uso crítico en $PUNTO: ${USO}%"
    echo "[$FECHA] $MENSAJE" >> "$LOG"
    ALERTA+="$MENSAJE\n"
  else
    echo "[$FECHA] ✅ $PUNTO está OK (${USO}%)" >> "$LOG"
  fi
done

echo "[$FECHA] Verificación finalizada" >> "$LOG"
echo "------------------------------" >> "$LOG"

# Enviar correo con resumen
echo -e "To: mario.villaverdebaron6@gmail.com
Subject: 🧪 Verificación de espacio en disco
From: mario.villaverdebaron6@gmail.com

La verificación del espacio en disco se ejecutó a las $FECHA.

Resumen:
$ALERTA

Consulta el log completo en:
$LOG
" | msmtp --from=default -t
