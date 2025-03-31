FROM debian:bullseye

# Instalar herramientas necesarias
RUN apt-get update && apt-get install -y cron bash tar mailutils
RUN apt-get update && apt-get install -y msmtp msmtp-mta mailutils ca-certificates

# Crear directorio para el script
WORKDIR /app

# Copiar el script y el archivo crontab
COPY backup.sh /app/backup.sh
COPY crontab.txt /etc/cron.d/backup-cron

# Dar permisos de ejecución al script
RUN chmod +x /app/backup.sh

# Dar permisos adecuados al cron
RUN chmod 0644 /etc/cron.d/backup-cron

# Aplicar el crontab
RUN crontab /etc/cron.d/backup-cron

# Crear archivo de log
RUN touch /var/log/cron.log

# Comando principal
CMD cron && tail -f /var/log/cron.log
