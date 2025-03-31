#!/bin/bash

LOG="/app/logs/limpieza.log"
RUTA="/app/tmp"

echo "🧹 Limpieza iniciada: $(date)" >> "$LOG"

if [ ! -d "$RUTA" ]; then
  echo "❌ Error: La carpeta $RUTA no existe." >> "$LOG"
  echo "----------------------------------------" >> "$LOG"
  exit 1
fi

ARCHIVOS=$(find "$RUTA" -type f -mtime +30)

if [ -z "$ARCHIVOS" ]; then
  echo "📭 No se encontraron archivos para limpiar." >> "$LOG"
else
  echo "$ARCHIVOS" >> "$LOG"
  echo "🗑️ Archivos eliminados:" >> "$LOG"
  echo "$ARCHIVOS" | xargs rm -f >> "$LOG" 2>&1
fi

echo "✅ Limpieza completada: $(date)" >> "$LOG"
echo "----------------------------------------" >> "$LOG"
