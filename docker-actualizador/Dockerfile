FROM debian:bullseye

RUN apt-get update && apt-get install -y cron bash msmtp

WORKDIR /app

COPY actualizador_sistema.sh /app/update.sh
COPY crontab.txt /etc/cron.d/update-cron

RUN chmod +x /app/update.sh && chmod 0644 /etc/cron.d/update-cron
RUN crontab /etc/cron.d/update-cron

CMD cron && tail -f /app/logs/actualizacion.log
