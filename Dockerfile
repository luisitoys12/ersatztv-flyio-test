FROM ghcr.io/ersatztv/legacy:latest

# Instalar rclone + fuse3
RUN apt-get update && apt-get install -y \
    curl \
    fuse3 \
    && curl https://rclone.org/install.sh | bash \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Permitir FUSE a usuarios no-root
RUN echo 'user_allow_other' >> /etc/fuse.conf

# Script de arranque
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 8409

ENTRYPOINT ["/entrypoint.sh"]
