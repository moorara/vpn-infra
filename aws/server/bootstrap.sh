#!/bin/bash

# Install Tools
apt update
apt upgrade -y
apt install -y curl jq socat

# Install X-UI
cd /opt
curl -Ls https://raw.githubusercontent.com/vaxilu/x-ui/master/install.sh --output install.sh
chmod +x install.sh
printf 'y\n${username}\n${password}\n${port}\n' | ./install.sh
rm install.sh
