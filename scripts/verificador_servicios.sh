#!/bin/bash

SERVICIOS=("nginx" "docker" "jenkins")
LOG="$HOME/scripts/verificador_servicios.log"
FECHA=$(date '+%F %T')
MENSAJE="===== Verificación de servicios - $FECHA =====\n"

for SERVICIO in "${SERVICIOS[@]}"; do
    MENSAJE+="🔍 Comprobando $SERVICIO...\n"
    
    if systemctl is-active --quiet "$SERVICIO"; then
        MENSAJE+="✅ $SERVICIO está activo\n"
    else
        MENSAJE+="❌ $SERVICIO está detenido. Intentando iniciar...\n"
        sudo systemctl start "$SERVICIO"
        
        if systemctl is-active --quiet "$SERVICIO"; then
            MENSAJE+="🔁 $SERVICIO iniciado correctamente\n"
        else
            MENSAJE+="🚫 Error al iniciar $SERVICIO\n"
        fi
    fi
done

# Guardar en el log
echo -e "$MENSAJE" >> "$LOG"

# Si el mensaje contiene algún error, enviar por correo
if echo "$MENSAJE" | grep -q "❌\|🚫"; then
    echo -e "$MENSAJE" | mail -s "🚨 Alerta: Falla en servicios" mario.villaverdebaron6@gmail.com
fi
