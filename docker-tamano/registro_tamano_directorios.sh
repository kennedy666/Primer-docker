#!/bin/bash

LOG="/app/logs/tamano.log"
FECHA=$(date "+%F %T")
CARPETAS="/app /var /tmp"

mkdir -p "$(dirname "$LOG")"

echo "[$FECHA] 📂 Registro de tamaño de directorios:" >> "$LOG"

for DIR in $CARPETAS; do
  if [ -d "$DIR" ]; then
    TAM=$(du -sh "$DIR" 2>/dev/null | cut -f1)
    echo " - $DIR: $TAM" >> "$LOG"
  fi
done

echo "------------------------------" >> "$LOG"
