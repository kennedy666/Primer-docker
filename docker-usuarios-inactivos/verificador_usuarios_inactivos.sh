#!/bin/bash

LOG="/app/logs/usuarios_inactivos.log"
FECHA=$(date "+%F %T")
DIAS_INACTIVOS=30

mkdir -p "$(dirname "$LOG")"

echo "[$FECHA] 👥 Verificando usuarios inactivos (>$DIAS_INACTIVOS días)..." >> "$LOG"

RESULTADOS=$(lastlog -b $DIAS_INACTIVOS | awk 'NR>1 && $NF != "**Never logged in**"')

if [ -n "$RESULTADOS" ]; then
  echo "$RESULTADOS" >> "$LOG"
  RESUMEN="$RESULTADOS"
else
  echo "[$FECHA] ✅ No hay usuarios inactivos recientes." >> "$LOG"
  RESUMEN="No hay usuarios inactivos en los últimos $DIAS_INACTIVOS días."
fi

echo "[$FECHA] Verificación finalizada." >> "$LOG"
echo "------------------------------" >> "$LOG"

# Enviar por correo
echo -e "To: mario.villaverdebaron6@gmail.com
Subject: 👥 Verificación de usuarios inactivos
From: mario.villaverdebaron6@gmail.com

Resultado de la verificación de usuarios inactivos a las $FECHA:

$RESUMEN

Consulta el log completo en:
$LOG
" | msmtp --from=default -t
