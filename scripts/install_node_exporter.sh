#!/bin/bash
set -e

NODE_EXPORTER_VER=1.9.1

echo "Installing Node Exporter version $NODE_EXPORTER_VER..."

# Create user for node_exporter
useradd --no-create-home --shell /bin/false node_exporter

# Download Node Exporter
cd /tmp
wget https://github.com/prometheus/node_exporter/releases/download/v${NODE_EXPORTER_VER}/node_exporter-${NODE_EXPORTER_VER}.linux-amd64.tar.gz

# Extract the file
tar xvf node_exporter-${NODE_EXPORTER_VER}.linux-amd64.tar.gz

# Move binary to /usr/local/bin
cp node_exporter-${NODE_EXPORTER_VER}.linux-amd64/node_exporter /usr/local/bin/

# Change ownership
chown node_exporter:node_exporter /usr/local/bin/node_exporter

# Create service configuration file
cat > /etc/systemd/system/node_exporter.service << EOF
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd
systemctl daemon-reload

# Enable and start service
systemctl enable node_exporter
systemctl start node_exporter

# Clean temporary files
rm -rf /tmp/node_exporter-${NODE_EXPORTER_VER}.linux-amd64*

echo "Node Exporter $NODE_EXPORTER_VER installed successfully"
echo "Service is running on port 9100" 