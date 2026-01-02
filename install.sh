#!/bin/bash

echo "🚀 Install SEON Stream App (Ubuntu 24.04)"

# update system
apt update -y
apt upgrade -y

# basic tools
apt install -y curl git ffmpeg

# install NodeJS 20 LTS
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt install -y nodejs

# check versions
node -v
npm -v

# clone repo
git clone https://github.com/ahmadsaroful-afk/streamflow-saya.git
cd streamflow-saya

# install dependencies
npm install

# start app
npm run start
