# DevPod - Self-Hosted Dev Cloud

DevPod is a comprehensive self-hosted development environment that integrates Git hosting, CI/CD pipelines, browser-based IDE, and package repositories into a cohesive platform.

## Architecture Overview

```
┌────────────┐   git push   ┌──────────────┐   webhooks   ┌─────────────┐
│ VS Code     │────────────▶│  Gitea        │────────────▶│ Drone CI     │
│  (code-server)│           └──────┬───────┘              └────┬────────┘
└─────┬──────┘  npm/pip|docker     │ build artifacts            │
      │ https / ssh                ▼                           │ publishes
      │                  ┌──────────────────┐                  │
      └─────────────────▶│ Verdaccio / Harbor│◀────────────────┘
                         └──────────────────┘
```

## Core Components

DevPod consists of the following core components:

1. **Gitea**: Git server for hosting repositories
2. **Drone CI**: CI/CD server and runner for automated builds and deployments
3. **Code Server**: Browser-based VS Code IDE
4. **Verdaccio**: NPM package registry
5. **PyPI Server**: Python package registry
6. **Docker Registry**: Container image registry
7. **Traefik**: Reverse proxy for routing and TLS termination
8. **Authelia**: Single sign-on authentication provider

## Prerequisites

- Linux server with Docker and Docker Compose installed
- Domain name (optional for production use)
- Open ports 80 and 443 (for external access)

## Installation

### Quick Start

1. Clone the DevPod repository:
```bash
git clone https://github.com/yourusername/devpod.git
cd devpod
```

2. Start the DevPod environment:
```bash
docker compose up -d
```

3. Access the services:
   - Gitea: http://gitea.localhost
   - Drone CI: http://drone.localhost
   - Code Server: http://code.localhost
   - Verdaccio: http://npm.localhost
   - PyPI Server: http://pypi.localhost
   - Docker Registry: http://registry.localhost
   - Authelia: http://auth.localhost
   - Traefik Dashboard: http://traefik.localhost

### Default Credentials

All services are protected by Authelia single sign-on with the following default credentials:

- Admin User:
  - Username: admin
  - Password: admin123
  
- Regular User:
  - Username: user
  - Password: user123

**Important**: Change these default passwords immediately after first login!

## Configuration

### Directory Structure

```
devpod/
├── docker-compose.yml
├── data/
│   ├── gitea/
│   ├── drone/
│   ├── code-server/
│   ├── verdaccio/
│   ├── pypi/
│   ├── registry/
│   ├── traefik/
│   └── authelia/
├── test_environment.sh
└── test_workflow.sh
```

### Service Configuration

Each service can be configured by modifying the corresponding configuration files in the `data` directory:

- **Gitea**: `data/gitea/app.ini`
- **Drone CI**: `data/drone/drone.env`
- **Code Server**: `data/code-server/config.env`
- **Verdaccio**: `data/verdaccio/conf/config.yaml`
- **PyPI Server**: `data/pypi/config.conf`
- **Docker Registry**: `data/registry/config.yml`
- **Traefik**: `data/traefik/traefik.yml` and `data/traefik/config/`
- **Authelia**: `data/authelia/configuration.yml` and `data/authelia/users_database.yml`

## Usage

### Development Workflow

1. **Code**: Write code in the browser-based VS Code (code-server)
2. **Commit**: Push code to Gitea repositories
3. **Build**: Drone CI automatically builds and tests your code
4. **Publish**: Artifacts are published to the appropriate registry (npm, PyPI, Docker)

### Example Workflow

1. Create a new repository in Gitea
2. Clone the repository in code-server
3. Add a `.drone.yml` file to configure the CI/CD pipeline
4. Push changes to trigger the pipeline
5. View build results in Drone CI
6. Access published artifacts from the registries

## Testing

DevPod includes two test scripts to verify the environment:

1. **Environment Test**: Verifies Docker installation and network connectivity
```bash
./test_environment.sh
```

2. **Workflow Test**: Sets up a test project to verify the complete CI/CD workflow
```bash
./test_workflow.sh
```

## Maintenance

### Backup

To backup the DevPod environment, create a snapshot of the `data` directory:

```bash
tar -czf devpod_backup_$(date +%Y%m%d).tar.gz ./data
```

### Updates

To update the DevPod environment:

1. Pull the latest changes:
```bash
git pull
```

2. Restart the services:
```bash
docker compose down
docker compose pull
docker compose up -d
```

### Logs

View logs for all services:

```bash
docker compose logs
```

View logs for a specific service:

```bash
docker compose logs [service-name]
```

## Security Considerations

- Change default passwords immediately after installation
- Enable HTTPS in production environments
- Regularly update all services
- Consider implementing network isolation for production deployments
- Review Authelia access control policies

## Customization

### Adding Custom Domains

To use custom domains instead of localhost:

1. Update the `docker-compose.yml` file to replace `.localhost` with your domain
2. Update the Traefik configuration to use Let's Encrypt for TLS certificates
3. Ensure your DNS records point to your server's IP address

### Scaling

For larger teams or higher workloads:

1. Increase Drone runner capacity in `docker-compose.yml`
2. Consider using a database backend for Gitea instead of SQLite
3. Implement proper storage solutions for the registries

## Troubleshooting

### Common Issues

1. **Service not starting**: Check logs with `docker compose logs [service-name]`
2. **Network connectivity issues**: Run `./test_network.sh` to verify connectivity
3. **Authentication failures**: Check Authelia logs and configuration
4. **CI/CD pipeline failures**: Check Drone CI logs and `.drone.yml` configuration

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
