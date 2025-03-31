FROM debian:bullseye

RUN apt-get update && apt-get install -y cron bash msmtp

WORKDIR /app

COPY verificador_espacio_critico.sh /app/espacio.sh
COPY crontab.txt /etc/cron.d/espacio-cron

RUN chmod +x /app/espacio.sh && chmod 0644 /etc/cron.d/espacio-cron
RUN crontab /etc/cron.d/espacio-cron

CMD cron && tail -f /app/logs/espacio.log
