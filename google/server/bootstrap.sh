#!/bin/bash

# Install Tools
apt update
apt upgrade -y
apt install -y curl unzip jq python3-pygments

# Install V2Ray
cd /opt
curl -Ls https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh --output install-v2ray.sh
chmod +x install-v2ray.sh
./install-v2ray.sh

# Start V2Ray Service
systemctl enable v2ray
systemctl start v2ray
