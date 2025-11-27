#!/bin/bash
# -------------------------------------------------------------
# Tech Ministry Docker Reset and Redeploy Script
# -------------------------------------------------------------
# This script completely removes all old Docker containers,
# images, volumes, and networks, then redeploys a clean
# environment using your docker-compose.yml file.
# -------------------------------------------------------------

set -e

echo "🧹 Stopping all running containers..."
sudo docker stop $(sudo docker ps -aq) || true

echo "🗑 Removing all containers..."
sudo docker rm $(sudo docker ps -aq) || true

echo "🧰 Removing all images..."
sudo docker rmi -f $(sudo docker images -q) || true

echo "💾 Removing all volumes (CAUTION: deletes data inside volumes)..."
sudo docker volume rm $(sudo docker volume ls -q) || true

echo "🌐 Removing all networks..."
sudo docker network rm $(sudo docker network ls -q) || true

echo "🧽 Pruning system..."
sudo docker system prune -a --volumes -f

echo "🧱 Recreating necessary directories..."
sudo mkdir -p /srv/mkdocs
sudo mkdir -p /srv/nginx/{www,conf,logs}
sudo mkdir -p /srv/mariadb/{data,conf}
sudo mkdir -p /srv/samba/internal_share
sudo mkdir -p /mnt/external_drive
sudo chown -R $USER:$USER /srv /mnt/external_drive

echo "🚀 Deploying Tech Ministry Docker stack..."
cd ~/techministry || (echo "❌ Error: ~/techministry directory not found." && exit 1)
sudo docker compose up -d

echo "✅ Deployment complete! Current containers:"
sudo docker ps

echo "📋 Logs from mkdocs container:"
sudo docker logs mkdocs --tail 20 || true

echo "✨ Tech Ministry stack is running fresh and clean!"

