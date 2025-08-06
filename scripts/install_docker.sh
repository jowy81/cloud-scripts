#!/bin/bash
set -e

DOCKER_VER=24.0.7
COMPOSE_VER=2.39.1

echo "Installing Docker version $DOCKER_VER and Docker Compose version $COMPOSE_VER..."

# Configure sysctl for Docker
echo "Configuring sysctl for Docker..."
cat > /etc/sysctl.d/99-docker.conf << EOF
vm.swappiness=10
vm.max_map_count=262144
EOF
sysctl -p /etc/sysctl.d/99-docker.conf

# Configure file limits for Docker
echo "Configuring file limits for Docker..."
cat >> /etc/security/limits.conf << EOF
* soft nofile 1048576
* hard nofile 1048576
root soft nofile 1048576
root hard nofile 1048576
EOF

# Update repositories
apt-get update

# Install dependencies
apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Add Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Set up the stable Docker repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update repositories
apt-get update

# Install Docker Engine
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Install specific Docker Compose
curl -L "https://github.com/docker/compose/releases/download/v${COMPOSE_VER}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Create symbolic link
ln -sf /usr/local/bin/docker-compose /usr/bin/docker-compose

# Enable and start Docker
systemctl enable docker
systemctl start docker

# Add current user to docker group
usermod -aG docker $SUDO_USER

# Disable UFW and configure iptables legacy for Docker
echo "Disabling UFW and configuring iptables legacy for Docker..."

# Stop and disable UFW
systemctl stop ufw
systemctl disable ufw

# Configure iptables legacy
update-alternatives --set iptables /usr/sbin/iptables-legacy
update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy

# Enable IP forwarding
echo 'net.ipv4.ip_forward=1' >> /etc/sysctl.d/99-docker.conf
sysctl -p /etc/sysctl.d/99-docker.conf

echo "Docker $DOCKER_VER and Docker Compose $COMPOSE_VER installed successfully"
echo "Please restart your session for docker group changes to take effect" 