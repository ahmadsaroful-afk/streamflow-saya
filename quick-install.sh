#!/usr/bin/env bash
set -e

export DEBIAN_FRONTEND=noninteractive

APP_DIR="/root/streamflow-saya"
REPO_URL="https://github.com/ahmadsaroful-afk/streamflow-saya.git"
PORT="7575"

echo "=== Streamflow Quick Install ==="

# Update system (PAKAI -y + aman dari prompt)
apt update -y
apt upgrade -y

# Tools
apt install -y curl git openssl ca-certificates

# Node.js 18
curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
apt install -y nodejs

# PM2
npm install -g pm2

# Clone project
cd /root
if [ -d "$APP_DIR/.git" ]; then
  cd "$APP_DIR" && git pull
else
  git clone "$REPO_URL" "$APP_DIR"
  cd "$APP_DIR"
fi

# Install dependencies
npm install

# Env
if [ ! -f ".env" ]; then
  echo "SESSION_SECRET=$(openssl rand -base64 32)" > .env
  echo "NODE_ENV=production" >> .env
fi

# Run app
pm2 delete streamflow >/dev/null 2>&1 || true
pm2 start app.js --name streamflow
pm2 save

# Auto start on reboot (INI yang benar-benar bikin auto-run)
pm2 startup systemd -u root --hp /root
pm2 save

# Firewall (kalau UFW ada)
if command -v ufw >/dev/null 2>&1; then
  ufw allow ${PORT}/tcp || true
  ufw reload || true
fi

echo "================================"
echo "SELESAI ✅"
echo "Akses: http://IP_VPS:${PORT}/login"
echo "Sekarang SSH/Termius BOLEH DITUTUP"
echo "================================"
