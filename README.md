# Cloud Scripts

Cloud-init configuration files and installation scripts for Linux servers.

## Repository Structure

```
cloud-scripts/
├── cloud-init_sample.yaml    # Base template
├── cloud-init_b.yaml         # Basic configuration
├── cloud-init_d.yaml         # Basic + Docker
├── cloud-init_bdn.yaml       # Basic + Docker + Node Exporter
├── scripts/
│   ├── install_docker.sh     # Docker installer
│   └── install_node_exporter.sh # Node Exporter installer
└── README.md
```

## Usage

### For personal use:
1. Fork this repository
2. Replace SSH keys in cloud-init files with your own
3. Use the appropriate cloud-init file with your cloud provider

### Cloud-init files:
- **cloud-init_b.yaml**: Basic setup with essential packages
- **cloud-init_d.yaml**: Basic setup + Docker
- **cloud-init_bdn.yaml**: Complete setup with Docker and monitoring

### Manual script execution:
```bash
# Install Docker
curl -s https://raw.githubusercontent.com/jowy81/cloud-scripts/main/scripts/install_docker.sh | bash

# Install Node Exporter
curl -s https://raw.githubusercontent.com/jowy81/cloud-scripts/main/scripts/install_node_exporter.sh | bash
```

## Configuration

- **Docker**: 24.0.7 + Compose 2.39.1
- **Node Exporter**: 1.7.0
- **Firewall**: UFW disabled for Docker compatibility, uses iptables legacy

## Author

jowy81 