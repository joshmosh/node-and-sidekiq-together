#!/bin/bash

echo "[Provisioning] Cleaning old packages..."
sudo apt-get autoremove > /dev/null

echo "[Provisioning] Updating packages..."
sudo apt-get update > /dev/null

echo "[Provisioning] Installing git and build packages..."
sudo apt-get install -y git build-essential libssl-dev libreadline-dev zlib1g-dev > /dev/null

echo "[Provisioning] Installing Redis..."
sudo apt-get install -y redis-server > /dev/null

echo "[Provisioning] Installing Yarn..."
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt-get update > /dev/null
sudo apt-get install yarn > /dev/null

echo "[Provisioning] Installing MongoDB"
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927 > /dev/null
echo "deb http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.2.list > /dev/null
sudo apt-get update > /dev/null
sudo apt-get install -y mongodb-org > /dev/null
