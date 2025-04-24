# DevPod Maintenance Guide

This guide provides instructions for maintaining and troubleshooting the DevPod self-hosted development environment.

## Routine Maintenance

### Backup Procedures

It's recommended to regularly backup your DevPod environment to prevent data loss:

1. **Full Backup**:
   ```bash
   cd /home/ubuntu
   tar -czf devpod_backup_$(date +%Y%m%d).tar.gz ./devpod/data
   ```

2. **Individual Service Backup**:
   ```bash
   # Backup Gitea repositories
   tar -czf gitea_backup_$(date +%Y%m%d).tar.gz ./devpod/data/gitea
   
   # Backup Docker Registry
   tar -czf registry_backup_$(date +%Y%m%d).tar.gz ./devpod/data/registry
   ```

### Updating Services

To update the DevPod services to their latest versions:

1. Pull the latest images:
   ```bash
   cd /home/ubuntu/devpod
   docker compose pull
   ```

2. Restart the services with new images:
   ```bash
   docker compose down
   docker compose up -d
   ```

### Monitoring

Monitor the health of your DevPod environment:

1. Check service status:
   ```bash
   docker compose ps
   ```

2. Monitor resource usage:
   ```bash
   docker stats
   ```

3. Check logs for errors:
   ```bash
   docker compose logs --tail=100
   ```

## Security Maintenance

### Password Management

1. **Update Authelia User Passwords**:
   Edit the `/home/ubuntu/devpod/data/authelia/users_database.yml` file and replace the password hashes.
   
   You can generate new password hashes using:
   ```bash
   docker run --rm authelia/authelia:latest authelia crypto hash generate argon2 --password 'your-new-password'
   ```

2. **Update Service Credentials**:
   - Gitea: Update through the web interface
   - Drone CI: Update environment variables in docker-compose.yml
   - Code Server: Update PASSWORD in docker-compose.yml
   - Package Registries: Update through their respective configuration files

### SSL/TLS Certificate Management

For production environments using Let's Encrypt:

1. Check certificate status:
   ```bash
   docker compose exec traefik traefik-cert-info /acme.json
   ```

2. Force certificate renewal:
   ```bash
   docker compose restart traefik
   ```

## Troubleshooting

### Service Failures

If a service fails to start or operate correctly:

1. Check the service logs:
   ```bash
   docker compose logs [service-name]
   ```

2. Verify the service configuration:
   ```bash
   docker compose config [service-name]
   ```

3. Restart the service:
   ```bash
   docker compose restart [service-name]
   ```

### Network Issues

If services cannot communicate with each other:

1. Verify the network exists:
   ```bash
   docker network ls | grep devpod_network
   ```

2. Inspect the network:
   ```bash
   docker network inspect devpod_network
   ```

3. Run the network test script:
   ```bash
   ./test_network.sh
   ```

### Storage Issues

If you encounter disk space issues:

1. Check available disk space:
   ```bash
   df -h
   ```

2. Clean up unused Docker resources:
   ```bash
   docker system prune -a
   ```

3. Consider implementing log rotation:
   ```bash
   # Add to crontab
   0 0 * * * docker compose logs --no-color > /home/ubuntu/devpod/logs/$(date +\%Y\%m\%d).log 2>&1
   ```

## Scaling and Performance

### Optimizing Performance

1. **Increase Drone Runner Capacity**:
   Edit the `docker-compose.yml` file and update the `DRONE_RUNNER_CAPACITY` environment variable.

2. **Upgrade Gitea Database**:
   For larger teams, consider switching from SQLite to MySQL or PostgreSQL.

3. **Implement Caching**:
   Add caching services for package registries to improve build times.

### Adding Additional Services

To extend DevPod with additional services:

1. Add the service definition to `docker-compose.yml`
2. Configure Traefik labels for routing
3. Add Authelia middleware for authentication
4. Create necessary data directories
5. Update documentation

## Disaster Recovery

In case of complete system failure:

1. Install Docker and Docker Compose on the new system
2. Restore the latest backup:
   ```bash
   tar -xzf devpod_backup_YYYYMMDD.tar.gz -C /home/ubuntu/
   ```
3. Start the environment:
   ```bash
   cd /home/ubuntu/devpod
   docker compose up -d
   ```

## Advanced Configuration

### Custom Domain Setup

To use custom domains instead of localhost:

1. Update the `docker-compose.yml` file to replace `.localhost` with your domain
2. Uncomment the Let's Encrypt configuration in `data/traefik/traefik.yml`
3. Update the email address for Let's Encrypt notifications
4. Restart Traefik:
   ```bash
   docker compose restart traefik
   ```

### External Database Integration

For production environments, consider using external databases:

1. Set up MySQL or PostgreSQL database servers
2. Update the Gitea configuration to use the external database
3. Restart the services to apply changes

## Appendix

### Important File Locations

- **Docker Compose**: `/home/ubuntu/devpod/docker-compose.yml`
- **Gitea Config**: `/home/ubuntu/devpod/data/gitea/app.ini`
- **Traefik Config**: `/home/ubuntu/devpod/data/traefik/traefik.yml`
- **Authelia Config**: `/home/ubuntu/devpod/data/authelia/configuration.yml`
- **Test Scripts**: `/home/ubuntu/devpod/test_environment.sh` and `/home/ubuntu/devpod/test_workflow.sh`

### Useful Commands

```bash
# Start all services
docker compose up -d

# Stop all services
docker compose down

# View logs for all services
docker compose logs

# View logs for a specific service
docker compose logs [service-name]

# Restart a specific service
docker compose restart [service-name]

# Check service status
docker compose ps

# Run environment test
./test_environment.sh

# Run workflow test
./test_workflow.sh
```
