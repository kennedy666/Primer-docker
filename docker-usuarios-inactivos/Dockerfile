FROM debian:bullseye

RUN apt-get update && apt-get install -y cron bash msmtp login

WORKDIR /app

COPY verificador_usuarios_inactivos.sh /app/usuarios.sh
COPY crontab.txt /etc/cron.d/usuarios-cron

RUN chmod +x /app/usuarios.sh && chmod 0644 /etc/cron.d/usuarios-cron
RUN crontab /etc/cron.d/usuarios-cron

CMD cron && tail -f /app/logs/usuarios_inactivos.log
