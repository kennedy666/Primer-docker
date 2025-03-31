#!/bin/bash

ORIGEN="/app/origen"
DESTINO="/app/destino"
LOG="/app/logs/sincronizador.log"
FECHA=$(date "+%F %T")

mkdir -p "$ORIGEN"
mkdir -p "$DESTINO"
mkdir -p "$(dirname "$LOG")"

echo "[$FECHA] 🔁 Iniciando sincronización de $ORIGEN -> $DESTINO" >> "$LOG"

rsync -av --delete "$ORIGEN/" "$DESTINO/" >> "$LOG" 2>&1

echo "[$FECHA] ✅ Sincronización finalizada" >> "$LOG"
echo "------------------------------" >> "$LOG"
