# DevPod User Guide

This guide provides instructions for using the DevPod self-hosted development environment.

## Getting Started

### Accessing DevPod Services

After the DevPod environment is up and running, you can access the following services:

- **Gitea (Git Server)**: http://gitea.localhost
- **Drone CI**: http://drone.localhost
- **Code Server (VS Code in browser)**: http://code.localhost
- **Verdaccio (NPM Registry)**: http://npm.localhost
- **PyPI Server**: http://pypi.localhost
- **Docker Registry**: http://registry.localhost
- **Authelia (SSO)**: http://auth.localhost
- **Traefik Dashboard**: http://traefik.localhost

### Authentication

All services are protected by Authelia single sign-on. Use the following default credentials:

- **Admin User**:
  - Username: `admin`
  - Password: `admin123`
  
- **Regular User**:
  - Username: `user`
  - Password: `user123`

**Important**: Change these default passwords immediately after first login!

## Development Workflow

### 1. Writing Code with Code Server

1. Access Code Server at http://code.localhost
2. Log in using your Authelia credentials
3. Create a new project or clone an existing repository from Gitea
4. Write and test your code in the browser-based VS Code environment

### 2. Version Control with Gitea

1. Access Gitea at http://gitea.localhost
2. Create a new repository for your project
3. Push your code to the repository using Git commands in Code Server terminal:
   ```bash
   git init
   git add .
   git commit -m "Initial commit"
   git remote add origin http://gitea.localhost/username/repo-name.git
   git push -u origin main
   ```

### 3. Continuous Integration with Drone CI

1. Access Drone CI at http://drone.localhost
2. Activate your repository in Drone CI
3. Add a `.drone.yml` file to your repository to define the CI/CD pipeline:
   ```yaml
   kind: pipeline
   type: docker
   name: default
   
   steps:
     - name: test
       image: node:16
       commands:
         - npm install
         - npm test
     
     - name: build
       image: node:16
       commands:
         - npm install
         - npm run build
   ```
4. Push changes to trigger the pipeline
5. View build results in Drone CI dashboard

### 4. Publishing Packages

#### NPM Packages (Verdaccio)

1. Configure npm to use the local registry:
   ```bash
   npm config set registry http://npm.localhost
   ```
2. Log in to the registry:
   ```bash
   npm login --registry http://npm.localhost
   ```
3. Publish your package:
   ```bash
   npm publish --registry http://npm.localhost
   ```

#### Python Packages (PyPI)

1. Create a `.pypirc` file in your home directory:
   ```
   [distutils]
   index-servers = local
   
   [local]
   repository: http://pypi.localhost
   username: admin
   password: admin123
   ```
2. Build and publish your package:
   ```bash
   python setup.py sdist bdist_wheel
   twine upload --repository local dist/*
   ```

#### Docker Images

1. Build your Docker image:
   ```bash
   docker build -t registry.localhost/myapp:latest .
   ```
2. Push the image to the local registry:
   ```bash
   docker push registry.localhost/myapp:latest
   ```

## Advanced Usage

### Using the Complete CI/CD Pipeline

1. Add a complete `.drone.yml` file to your repository:
   ```yaml
   kind: pipeline
   type: docker
   name: default
   
   steps:
     - name: test
       image: node:16
       commands:
         - npm install
         - npm test
     
     - name: build
       image: node:16
       commands:
         - npm install
         - npm run build
     
     - name: publish
       image: plugins/docker
       settings:
         registry: registry.localhost
         repo: registry.localhost/myapp
         tags:
           - latest
           - ${DRONE_COMMIT_SHA:0:8}
       when:
         branch:
           - main
   ```
2. Push changes to trigger the complete pipeline
3. The pipeline will test, build, and publish your application automatically

### Installing VS Code Extensions

1. Access Code Server at http://code.localhost
2. Open the Extensions panel (Ctrl+Shift+X)
3. Search for and install extensions as needed
4. Recommended extensions are pre-installed:
   - Docker support
   - Git integration
   - Language support for JavaScript, Python, Go, Java, and Rust
   - Remote development tools
   - Productivity tools

### Customizing Your Environment

1. Modify service configurations in the `data` directory
2. Restart services with `docker compose restart [service-name]`
3. Add custom domains by updating the `docker-compose.yml` file

## Troubleshooting

### Common Issues

1. **Authentication Issues**:
   - Clear browser cookies and cache
   - Ensure you're using the correct credentials
   - Check Authelia logs: `docker compose logs authelia`

2. **Service Not Accessible**:
   - Verify the service is running: `docker compose ps`
   - Check service logs: `docker compose logs [service-name]`
   - Ensure Traefik is properly configured

3. **CI/CD Pipeline Failures**:
   - Check Drone CI logs for the specific build
   - Verify your `.drone.yml` file is correctly formatted
   - Ensure your tests are properly configured

4. **Package Publishing Issues**:
   - Verify you have the correct permissions
   - Check registry logs: `docker compose logs verdaccio` or `docker compose logs pypi`
   - Ensure you're using the correct registry URL

## Getting Help

If you encounter issues not covered in this guide, please:

1. Check the logs: `docker compose logs`
2. Review the README.md file for additional information
3. Run the test scripts to verify your environment: `./test_environment.sh` and `./test_workflow.sh`
4. Contact your system administrator for assistance
