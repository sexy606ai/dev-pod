#!/bin/bash
# DevPod CI/CD Workflow Test
# This script tests the complete CI/CD workflow from code to registry

echo "===== DevPod CI/CD Workflow Test ====="

# Create test project directory
mkdir -p /home/ubuntu/devpod/test-project
cd /home/ubuntu/devpod/test-project

# Create a simple Node.js application
echo "Creating test Node.js application..."
cat > package.json << 'EOF'
{
  "name": "devpod-test-app",
  "version": "1.0.0",
  "description": "Test application for DevPod CI/CD workflow",
  "main": "index.js",
  "scripts": {
    "test": "echo \"Tests passed\" && exit 0",
    "build": "echo \"Build completed\" && exit 0",
    "start": "node index.js"
  },
  "author": "DevPod User",
  "license": "MIT"
}
EOF

cat > index.js << 'EOF'
console.log('DevPod test application is running!');
EOF

# Create a Dockerfile
cat > Dockerfile << 'EOF'
FROM node:16-alpine
WORKDIR /app
COPY package.json .
COPY index.js .
RUN npm install
CMD ["npm", "start"]
EOF

# Create a Drone CI pipeline file
cat > .drone.yml << 'EOF'
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
      repo: registry.localhost/devpod-test-app
      tags:
        - latest
        - ${DRONE_COMMIT_SHA:0:8}
    when:
      branch:
        - main
EOF

# Create a Git repository
echo "Initializing Git repository..."
git init
git config --global user.email "test@devpod.local"
git config --global user.name "DevPod Test"
git add .
git commit -m "Initial commit"

echo "===== DevPod CI/CD Workflow Test Setup Completed ====="
echo "To test the workflow:"
echo "1. Start the DevPod environment: cd /home/ubuntu/devpod && docker compose up -d"
echo "2. Create a new repository in Gitea: http://gitea.localhost"
echo "3. Push this test project to the Gitea repository"
echo "4. Activate the repository in Drone CI: http://drone.localhost"
echo "5. Push a new commit to trigger the CI/CD pipeline"
echo "6. Check the Docker Registry for the published image: http://registry.localhost"
