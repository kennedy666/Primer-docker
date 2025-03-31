FROM debian:bullseye

RUN apt-get update && apt-get install -y cron bash rsync

WORKDIR /app

COPY sincronizador_directorios.sh /app/sync.sh
COPY crontab.txt /etc/cron.d/sync-cron

RUN chmod +x /app/sync.sh && chmod 0644 /etc/cron.d/sync-cron
RUN crontab /etc/cron.d/sync-cron

CMD cron && tail -f /app/logs/sincronizador.log
