#!/bin/bash

# === CONFIGURACIÓN ===
FECHA=$(date '+%F %T')
LOGDIR="$HOME/mi-primer-repo-git/logs"
LOG="$LOGDIR/alerta_inmediata.log"
CORREO="mario.villaverdebaron6@gmail.com"
UMBRAL=60
ALERTA=""

# Crear carpeta de logs si no existe
mkdir -p "$LOGDIR"

# === DISCO ===
DISCO=$(df -h / | awk 'NR==2 {print $5}')
DISCO_PORC=${DISCO%\%}
[ "$DISCO_PORC" -ge "$UMBRAL" ] && ALERTA+="💾 Disco / supera el $UMBRAL%: $DISCO_PORC%\n"

# === RAM USADA ===
RAM_TOTAL=$(free -m | awk '/Mem:/ {print $2}')
RAM_USED=$(free -m | awk '/Mem:/ {print $3}')
RAM_PORC=$((100 * RAM_USED / RAM_TOTAL))
[ "$RAM_PORC" -ge "$UMBRAL" ] && ALERTA+="🧠 RAM usada supera el $UMBRAL%: $RAM_PORC%\n"

# === CPU USO (conversión segura a entero) ===
CPU_PORC_RAW=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')
CPU_PORC_INT=$(printf "%.0f" "$CPU_PORC_RAW")
[ "$CPU_PORC_INT" -ge "$UMBRAL" ] && ALERTA+="🧮 CPU supera el $UMBRAL%: $CPU_PORC_INT%\n"

# === GPU (opcional) ===
if command -v nvidia-smi &> /dev/null; then
    GPU_USO=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits | head -n1)
    [ "$GPU_USO" -ge "$UMBRAL" ] && ALERTA+="🎮 GPU supera el $UMBRAL%: $GPU_USO%\n"
fi

# === ENVIAR ALERTA SI CORRESPONDE ===
if [ -n "$ALERTA" ]; then
    MENSAJE="🚨 ALERTA INMEDIATA - $FECHA\n\n$ALERTA"
    echo -e "$MENSAJE" | mail -s "🚨 ALERTA: Recursos del sistema críticos" "$CORREO"
    echo -e "$MENSAJE\n---" >> "$LOG"
else
    echo -e "[$FECHA] ✅ Todo en orden (uso dentro de límites)" >> "$LOG"
fi
