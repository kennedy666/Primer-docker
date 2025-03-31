FROM debian:bullseye

RUN apt-get update && apt-get install -y cron bash procps

WORKDIR /app

COPY monitor_cpu_ram.sh /app/monitor.sh
COPY crontab.txt /etc/cron.d/monitor-cron

RUN chmod +x /app/monitor.sh && chmod 0644 /etc/cron.d/monitor-cron
RUN crontab /etc/cron.d/monitor-cron

CMD cron && tail -f /app/logs/monitor.log
