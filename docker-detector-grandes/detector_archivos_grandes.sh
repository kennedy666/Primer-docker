#!/bin/bash

DIR="/app"
LOG="/app/logs/grandes.log"
FECHA=$(date "+%F %T")

mkdir -p "$(dirname "$LOG")"

echo "[$FECHA] 🔍 Buscando archivos > 500MB en $DIR" >> "$LOG"

RESULTADOS=$(find "$DIR" -type f -size +500M -exec ls -lh {} \; 2>/dev/null)

if [ -n "$RESULTADOS" ]; then
  echo "$RESULTADOS" >> "$LOG"
  RESUMEN="$RESULTADOS"
else
  echo "[$FECHA] ✅ No se encontraron archivos grandes." >> "$LOG"
  RESUMEN="No se encontraron archivos mayores a 500MB."
fi

echo "[$FECHA] Búsqueda completada." >> "$LOG"
echo "------------------------------" >> "$LOG"

# Enviar por correo
echo -e "To: mario.villaverdebaron6@gmail.com
Subject: 🔍 Resultado de archivos grandes
From: mario.villaverdebaron6@gmail.com

Resultado de la búsqueda de archivos mayores a 500MB ejecutada a las $FECHA:

$RESUMEN

Consulta el log completo en:
$LOG
" | msmtp --from=default -t
