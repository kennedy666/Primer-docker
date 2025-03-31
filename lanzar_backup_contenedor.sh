#!/bin/bash

# Elimina el contenedor anterior si existe
docker rm -f mi-backup-cron 2>/dev/null

# Lanza el contenedor con los volúmenes montados
docker run -d \
  --name mi-backup-cron \
  -v ~/mi-primer-repo-git/carpeta_original:/data/original \
  -v ~/mi-primer-repo-git/backups:/data/backups \
  -v ~/mi-primer-repo-git/logs/backup:/app/logs \
  backup-script-cron

echo "✅ Contenedor lanzado como 'mi-backup-cron' con volúmenes correctamente montados."
