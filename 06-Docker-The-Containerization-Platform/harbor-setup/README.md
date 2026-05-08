## Offline Harbor Registry Setup on Ubuntu (Vagrant VM)

This guide walks you through installing **Harbor** (v2.13.1) in **offline mode** on a fresh **Ubuntu virtual machine** created using **Vagrant**.

### [Prerequisites](https://goharbor.io/docs/2.13.0/install-config/installation-prereqs/)

### I followed the following steps:
1. Created fresh VM using Vagrant with [Vagrantfile](https://github.com/erkdk/devops-journey/blob/main/06-docker/harbor-setup/Vagrantfile).
2. [Installed Docker Engine.](https://docs.docker.com/engine/install/ubuntu/)
3. [Manage Docker as a non-root user](https://docs.docker.com/engine/install/linux-postinstall)
4. Installed OpenSSL and created SSL certificates.
```bash
sudo apt install -y openssl

# Create SSL directory
sudo mkdir -p /etc/harbor/ssl
cd /etc/harbor/ssl

# Generate self-signed cert
sudo openssl req -newkey rsa:4096 -nodes -sha256 -keyout harbor.key -x509 -days 365 -out harbor.crt

```

4. Downloaded and extracted Offline Harbor Installer.
```bash
cd ~
wget https://github.com/goharbor/harbor/releases/download/v2.13.1/harbor-offline-installer-v2.13.1.tgz
tar -zxvf harbor-offline-installer-v2.13.1.tgz
cd harbor
```
5. Copied the default config.
```bash
cp harbor.yml.tmpl harbor.yml
```
6. Edited harbor.yml with the following:
```bash
nano harbor.yml
```
and updated: 
```bash
hostname: harbor.local
https:
  port: 443
  certificate: /etc/harbor/ssl/harbor.crt
  private_key: /etc/harbor/ssl/harbor.key
harbor_admin_password: Harbor12345 (Choose Yourself)
```
7. Ran the script to install Harbor
```bash
sudo ./install.sh
```
8. Opened your browser and accessed Harbor UI:
```bash
https://192.168.56.10

Username: admin
Password: Harbor12345
```
9. To restart the harbor after vagrant reboot:
```bash
cd ~/harbor
sudo docker compose up -d
```    




#### References
- [Harbor Official GitHub](https://github.com/goharbor/harbor)
- [Harbor Documentation](https://goharbor.io/docs/2.13.0/)
- [Docker Engine Install Guide](https://docs.docker.com/engine/install/ubuntu/)





