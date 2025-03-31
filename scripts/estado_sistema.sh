#!/bin/bash

# === CONFIGURACIÓN ===
FECHA=$(date '+%F %T')
LOGDIR="$HOME/mi-primer-repo-git/logs"
LOG="$LOGDIR/estado_sistema.log"
TEMP="$LOGDIR/estado_sistema_temp.log"
CORREO="mario.villaverdebaron6@gmail.com"
UMBRAL=60

# Crear carpeta de logs si no existe
mkdir -p "$LOGDIR"

# === DISCO ===
DISCO=$(df -h / | awk 'NR==2 {print $5}')
DISCO_PORC=${DISCO%\%}

# === RAM USADA ===
RAM_TOTAL=$(free -m | awk '/Mem:/ {print $2}')
RAM_USED=$(free -m | awk '/Mem:/ {print $3}')
RAM_PORC=$((100 * RAM_USED / RAM_TOTAL))

# === CPU USO ===
CPU_PORC=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')
CPU_PORC_INT=${CPU_PORC%.*}

# === GPU (opcional) ===
if command -v nvidia-smi &> /dev/null; then
    GPU_INFO=$(nvidia-smi --query-gpu=utilization.gpu,memory.used,memory.total --format=csv,noheader,nounits)
    GPU_USO=$(echo $GPU_INFO | awk -F',' '{print $1}')
    GPU_MEM_USED=$(echo $GPU_INFO | awk -F',' '{print $2}')
    GPU_MEM_TOTAL=$(echo $GPU_INFO | awk -F',' '{print $3}')
    GPU_LINE="🎮 GPU: Uso $GPU_USO% - Memoria $GPU_MEM_USED MiB / $GPU_MEM_TOTAL MiB"
else
    GPU_LINE="🎮 GPU: No detectada o nvidia-smi no instalado"
fi

# === GENERAR REPORTE ===
echo -e "📊 Estado del sistema - $FECHA\n" > "$TEMP"
echo -e "💾 Disco / : Uso $DISCO" >> "$TEMP"
echo -e "🧠 RAM: $RAM_USED MB usada de $RAM_TOTAL MB ($RAM_PORC%)" >> "$TEMP"
echo -e "🧮 CPU: Uso actual: $CPU_PORC_INT%" >> "$TEMP"
echo -e "$GPU_LINE\n" >> "$TEMP"

# === ALERTAS (informativa, no urgente) ===
if [ "$DISCO_PORC" -ge "$UMBRAL" ] || [ "$RAM_PORC" -ge "$UMBRAL" ] || [ "$CPU_PORC_INT" -ge "$UMBRAL" ]; then
    echo -e "⚠️  ALERTA: Se superó el umbral del $UMBRAL% en uno o más recursos.\n" >> "$TEMP"
fi

# === LOG Y ENVÍO ===
cat "$TEMP" >> "$LOG"
mail -s "📋 Estado diario del sistema - $FECHA" "$CORREO" < "$TEMP"
