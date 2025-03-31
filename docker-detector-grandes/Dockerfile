FROM debian:bullseye

RUN apt-get update && apt-get install -y cron bash msmtp

WORKDIR /app

COPY detector_archivos_grandes.sh /app/grandes.sh
COPY crontab.txt /etc/cron.d/grandes-cron

RUN chmod +x /app/grandes.sh && chmod 0644 /etc/cron.d/grandes-cron
RUN crontab /etc/cron.d/grandes-cron

CMD cron && tail -f /app/logs/grandes.log
