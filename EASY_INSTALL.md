# DevPod Easy Installation Guide

This guide provides simple step-by-step instructions to get your DevPod environment up and running quickly.

## Prerequisites

- A Linux server (Ubuntu 20.04+ recommended)
- Root or sudo access
- Open ports 80 and 443 (for external access)

## Quick Installation (Copy & Paste)

### 1. Install Docker

```bash
# Update system packages
sudo apt update

# Install required packages
sudo apt install -y curl git

# Install Docker
curl -fsSL https://get.docker.com | sudo sh

# Add your user to the docker group (replace 'yourusername' with your actual username)
sudo usermod -aG docker $USER

# Apply group changes (or log out and back in)
newgrp docker
```

### 2. Clone the DevPod Repository

```bash
# Clone the repository
git clone https://github.com/sexy606ai/DevPod.git

# Navigate to the DevPod directory
cd DevPod
```

### 3. Start DevPod

```bash
# Start all services
docker compose up -d
```

That's it! Your DevPod environment is now running.

## Accessing Your Services

After installation, you can access your services at:

- **Gitea (Git Server)**: http://gitea.localhost
- **Drone CI**: http://drone.localhost
- **Code Server (VS Code)**: http://code.localhost
- **Verdaccio (NPM Registry)**: http://npm.localhost
- **PyPI Server**: http://pypi.localhost
- **Docker Registry**: http://registry.localhost
- **Authelia (SSO)**: http://auth.localhost
- **Traefik Dashboard**: http://traefik.localhost

## Default Login Credentials

All services use Authelia single sign-on with these default credentials:

- **Admin User**:
  - Username: `admin`
  - Password: `admin123`
  
- **Regular User**:
  - Username: `user`
  - Password: `user123`

**Important**: Change these default passwords immediately after first login!

## Basic Commands

```bash
# Start all services
docker compose up -d

# Stop all services
docker compose down

# View logs
docker compose logs

# Restart a specific service (e.g., gitea)
docker compose restart gitea
```

## Troubleshooting

1. **Can't access services with .localhost domains?**
   - Add entries to your `/etc/hosts` file:
     ```
     127.0.0.1 gitea.localhost drone.localhost code.localhost npm.localhost pypi.localhost registry.localhost auth.localhost traefik.localhost
     ```

2. **Docker permission issues?**
   - Make sure you've added your user to the docker group and logged out and back in.

3. **Port conflicts?**
   - Check if ports 80 and 443 are already in use:
     ```bash
     sudo lsof -i :80
     sudo lsof -i :443
     ```
   - Stop conflicting services or modify the ports in docker-compose.yml

## Next Steps

For more detailed information, check out:

- [README.md](README.md) - Complete setup guide and overview
- [USER_GUIDE.md](USER_GUIDE.md) - Instructions for developers
- [MAINTENANCE.md](MAINTENANCE.md) - Guide for system administrators
