# Pi Node Ubuntu 24.04 Installer 🚀

![Pi Network Logo](https://minepi.com/favicon.ico)

Automatic installer for **Pi Node (Official Version)** on **Ubuntu 24.04 LTS**.  
Makes it easier to set up a node from scratch until it is ready to run the Pi protocol.

---

## 🔥 Project Status

| Component | Status |
|-----------|--------|
| Docker    | ![Docker](https://img.shields.io/badge/Docker-Installed-blue) |
| Pi Node   | ![Pi Node](https://img.shields.io/badge/Pi_Node-Ready-brightgreen) |
| Ubuntu    | ![Ubuntu](https://img.shields.io/badge/Ubuntu-24.04-orange) |

---

## 📦 Main Features

- Install dependencies (`ca-certificates`, `curl`, `gnupg`)
- Set up Docker CE (container runtime)
- Add the official Pi Network repository
- Install the official Pi Node CLI
- Initialize the node to participate in the network
- Reset the Horizon database if needed
- Monitor node & ledger status

---

## ⚙️ Requirements

- Ubuntu 24.04 LTS (amd64)
- User with `sudo` or `root` access
- Stable internet connection
- Minimum 2GB RAM (4GB+ recommended)
- Minimum 10GB storage

---

## 🚀 Installation Guide

### 1. Clone the repository

```bash
git clone https://github.com/zendshost/Pi-Node-Ubuntu-24.04.git
cd Pi-Node-Ubuntu-24.04
```

---

### 2. Give execute permission

```bash
chmod +x install.sh
```

---

### 3. Run the installer

```bash
sudo ./install.sh
```

---

## 🐳 Docker Verification

Check Docker installation:

```bash
docker --version
```

Check Docker service:

```bash
sudo systemctl status docker
```

---

## 📡 Pi Node Commands

### Check node status

```bash
pi-node status
```

### Start node

```bash
pi-node start
```

### Stop node

```bash
pi-node stop
```

### Restart node

```bash
pi-node restart
```

---

## 🛠 Reset Horizon Database

If your node is stuck or ledger synchronization fails:

```bash
pi-node horizon-db reset
```

Then restart the node:

```bash
pi-node restart
```

---

## 📊 Monitor Logs

View live Pi Node logs:

```bash
docker logs -f pi-consensus
```

Or:

```bash
journalctl -u docker -f
```

---

## 🔒 Security Notes

- Always keep Ubuntu updated
- Do not share your node private keys
- Use a firewall such as `ufw`
- Only install packages from trusted sources

---

## 📁 Recommended Ports

| Port | Usage |
|------|-------|
| 31400 | Pi Node API |
| 31401 | Consensus |
| 22 | SSH |

Open ports using UFW:

```bash
sudo ufw allow 31400/tcp
sudo ufw allow 31401/tcp
sudo ufw allow 22/tcp
```

---

## ✅ Update System

```bash
sudo apt update && sudo apt upgrade -y
```

---

## ❌ Uninstall Pi Node

```bash
sudo apt remove pi-node -y
sudo docker system prune -a
```

---

## 🤝 Contributing

Pull requests and improvements are welcome.

---

## 📜 License

MIT License

---

## ⭐ Support

If this project helps you, give it a star on GitHub ⭐
