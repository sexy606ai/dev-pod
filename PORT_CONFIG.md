# Port Configuration for Raspberry Pi

This document explains the port configuration changes made to avoid conflicts on Raspberry Pi systems.

## Port Changes

The following port changes were made to avoid conflicts with existing services:

| Service | Original Port | New Port |
|---------|--------------|----------|
| Traefik HTTP | 80 | 3080 |
| Traefik HTTPS | 443 | 3443 |
| Traefik Dashboard | 8080 | 7000 |

## Accessing Services

After these changes, you'll access your services using the new ports:

- Gitea: http://gitea.localhost:3080
- Drone CI: http://drone.localhost:3080
- Code Server: http://code.localhost:3080
- Verdaccio: http://npm.localhost:3080
- PyPI Server: http://pypi.localhost:3080
- Docker Registry: http://registry.localhost:3080
- Authelia: http://auth.localhost:3080
- Traefik Dashboard: http://traefik.localhost:7000

## Troubleshooting

If you still encounter port conflicts, check which ports are in use:
```bash
sudo netstat -tulpn | grep LISTEN
```

Then choose different port numbers that aren't already in use.
