#!/bin/bash
set -euo pipefail

echo -e "\e[1;34m[INFO] Installation / Upgrade Pi Node (Official Version)\e[0m"

###############################################
# 1. Install dependencies
###############################################
echo -e "\e[1;32m[1/10] Install dependencies...\e[0m"
sudo apt update
sudo apt install -y ca-certificates curl gnupg lsb-release

###############################################
# 2. Install Docker if not already installed
###############################################
if ! command -v docker &> /dev/null; then
    echo -e "\e[1;32m[2/10] Install Docker...\e[0m"
    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
      | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io
    sudo systemctl enable --now docker
else
    echo -e "\e[1;33mDocker is already installed, continuing...\e[0m"
fi

###############################################
# 3. Add Pi Network repo if not already added
###############################################
if [ ! -f /etc/apt/sources.list.d/pinetwork.list ]; then
    echo -e "\e[1;32m[3/10] Add Pi Network repository...\e[0m"
    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://apt.minepi.com/repository.gpg.key \
      | sudo gpg --dearmor -o /etc/apt/keyrings/pinetwork-archive-keyring.gpg
    sudo chmod a+r /etc/apt/keyrings/pinetwork-archive-keyring.gpg
    echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/pinetwork-archive-keyring.gpg] https://apt.minepi.com stable main" \
      | sudo tee /etc/apt/sources.list.d/pinetwork.list > /dev/null
fi

###############################################
# 4. Install / Upgrade pi-node CLI
###############################################
echo -e "\e[1;32m[4/10] Install / Upgrade pi-node CLI...\e[0m"
sudo apt update
sudo apt install -y pi-node
pi-node --version

###############################################
# 5. Backup old node if it exists
###############################################
if [ -d "$HOME/pi-node" ]; then
    echo -e "\e[1;33mBackup old node data...\e[0m"
    TIMESTAMP=$(date +%Y%m%d_%H%M%S)
    mv "$HOME/pi-node" "$HOME/pi-node-backup-$TIMESTAMP"
fi

###############################################
# 6. Stop old container if it exists
###############################################
if docker ps -a --format '{{.Names}}' | grep -q '^mainnet$'; then
    echo -e "\e[1;33mStop old container...\e[0m"
    docker stop mainnet || true
    docker rm mainnet || true
fi

###############################################
# 7. Initialize / Upgrade node
###############################################
echo -e "\e[1;32m[5/10] Initialize / Upgrade Pi Node...\e[0m"
pi-node initialize

###############################################
# 8. Wait for node & Horizon to be ready
###############################################
echo "Waiting for Horizon to be ready..."
while true; do
    STATUS=$(pi-node status | grep "Horizon Status" -A2 | grep "Status" | awk '{print $2}')
    if [ "$STATUS" == "✅" ]; then
        echo -e "\e[1;32mHorizon is now running.\e[0m"
        break
    else
        echo -e "\e[1;33mSync process in progress. Please wait...\e[0m"
        sleep 15
    fi
done

echo
echo -e "\e[1;32mPi Network node is ready to use!\e[0m"

###############################################
# 9. Run automatic node status
###############################################
echo -e "\e[1;36mRunning pi-node status...\e[0m"
pi-node status

echo -e "\e[1;36mRunning pi-node protocol-status...\e[0m"
pi-node protocol-status

###############################################
# 10. Closing message
###############################################
echo "Enter node folder: cd /root/pi-node"
