#!/bin/bash
# Ejecuta estos comandos UNA SOLA VEZ para configurar los secrets en Fly.io
# Nunca subas este archivo con datos reales al repo

# Sube tu rclone.conf como secret
fly secrets set RCLONE_CONFIG="$(cat rclone.conf)"

# Rutas de cada canal en Terabox
fly secrets set TERABOX_CANAL1_PATH="/MisVideos/Canal1"
fly secrets set TERABOX_CANAL2_PATH="/MisVideos/Canal2"
fly secrets set TERABOX_CANAL3_PATH="/MisVideos/Comerciales"
