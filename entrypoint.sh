#!/bin/bash
set -e

echo "==> Montando Terabox via rclone WebDAV..."

# Crear directorios de montaje para los 3 canales
mkdir -p /mnt/canal1 /mnt/canal2 /mnt/canal3

# Montar cada carpeta desde Terabox
# Las variables RCLONE_* vienen de los secrets de Fly.io
rclone mount "terabox:${TERABOX_CANAL1_PATH:-/canal1}" /mnt/canal1 \
  --config /config/rclone.conf \
  --vfs-cache-mode full \
  --vfs-cache-max-size 5G \
  --allow-other \
  --daemon

rclone mount "terabox:${TERABOX_CANAL2_PATH:-/canal2}" /mnt/canal2 \
  --config /config/rclone.conf \
  --vfs-cache-mode full \
  --vfs-cache-max-size 5G \
  --allow-other \
  --daemon

rclone mount "terabox:${TERABOX_CANAL3_PATH:-/canal3}" /mnt/canal3 \
  --config /config/rclone.conf \
  --vfs-cache-mode full \
  --vfs-cache-max-size 5G \
  --allow-other \
  --daemon

echo "==> Montajes listos. Iniciando ErsatzTV..."
exec /init
