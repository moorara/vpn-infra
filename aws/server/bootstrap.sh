#!/bin/bash

# Install Tools
apt update
apt upgrade -y
apt install -y curl unzip jq socat python3-pygments

# Install X-UI
cd /opt
curl -Ls https://raw.githubusercontent.com/vaxilu/x-ui/master/install.sh --output install-x-ui.sh
chmod +x install-x-ui.sh
printf 'y\n${username}\n${password}\n${port}\n' | ./install-x-ui.sh
