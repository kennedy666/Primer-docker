#!/bin/bash

FECHA=$(date +"%Y-%m-%d-%H-%M")
DESTINO="/app/backups"
ORIGEN="/app/carpeta_original"
LOG="/app/logs/backup/backup.log"
LOG_DIARIO="/app/logs/backup/backup_diario_$(date +'%Y-%m-%d').txt"

echo "------------------------------------------" >> "$LOG"
echo "📦 Backup iniciado: $FECHA" >> "$LOG"
echo "📁 Origen: $ORIGEN" >> "$LOG"
echo "📁 Destino: $DESTINO/backup-$FECHA.tar.gz" >> "$LOG"

# Crear backup
tar -czf "$DESTINO/backup-$FECHA.tar.gz" -C "$ORIGEN" . 2>> "$LOG"

# Verificar éxito
if [ $? -eq 0 ]; then
    echo "✅ Backup hecho correctamente." >> "$LOG"
    
    # Eliminar backups más antiguos si hay más de 5
    TOTAL=$(ls -1t "$DESTINO"/backup-*.tar.gz 2>/dev/null | wc -l)
    if [ "$TOTAL" -gt 5 ]; then
        ELIMINAR=$(ls -1t "$DESTINO"/backup-*.tar.gz | tail -n +6)
        for archivo in $ELIMINAR; do
            rm "$archivo"
            echo "🗑️ Versión antigua eliminada (límite 5): $archivo" >> "$LOG"
        done
    fi

    # Guardar informe diario y enviar
    tail -n 100 "$LOG" > "$LOG_DIARIO"
    echo "📋 Informe diario de backup - $(date +'%Y-%m-%d')" | \
        mail -s "📬 Informe Backup Diario - $(date +'%Y-%m-%d')" -A "$LOG_DIARIO" mario.villaverdebaron6@gmail.com

else
    echo "❌ ERROR en el backup." >> "$LOG"
    echo "🚨 Error detectado en backup - $(date +'%Y-%m-%d')" | \
        mail -s "🚨 ERROR en Backup - $(date +'%Y-%m-%d')" mario.villaverdebaron6@gmail.com
fi
