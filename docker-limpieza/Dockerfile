FROM debian:bullseye

RUN apt-get update && apt-get install -y cron bash tar mailutils

WORKDIR /app

COPY limpieza_archivos_antiguos.sh /app/limpieza_archivos_antiguos.sh
COPY crontab.txt /etc/cron.d/limpieza-cron

RUN chmod +x /app/limpieza_archivos_antiguos.sh && chmod 0644 /etc/cron.d/limpieza-cron

# ✅ Solución aquí
RUN mkdir -p /app/logs
RUN crontab /etc/cron.d/limpieza-cron && touch /app/logs/limpieza.log

CMD ["cron", "-f"]

