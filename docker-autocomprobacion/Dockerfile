FROM debian:bullseye

RUN apt-get update && apt-get install -y cron bash systemctl

WORKDIR /app

COPY autocomprobacion_so.sh /app/autocheck.sh
COPY crontab.txt /etc/cron.d/autocheck-cron

RUN chmod +x /app/autocheck.sh && chmod 0644 /etc/cron.d/autocheck-cron
RUN crontab /etc/cron.d/autocheck-cron

CMD cron && tail -f /app/logs/autocomprobacion.log
