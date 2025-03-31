FROM debian:bullseye

RUN apt-get update && apt-get install -y cron bash

WORKDIR /app

COPY registro_tamano_directorios.sh /app/tamano.sh
COPY crontab.txt /etc/cron.d/tamano-cron

RUN chmod +x /app/tamano.sh && chmod 0644 /etc/cron.d/tamano-cron
RUN crontab /etc/cron.d/tamano-cron

CMD cron && tail -f /app/logs/tamano.log
