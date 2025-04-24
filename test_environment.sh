#!/bin/bash
# DevPod Test Script
# This script tests the complete DevPod environment

echo "===== DevPod Environment Test ====="
echo "Testing Docker installation..."
docker --version
if [ $? -eq 0 ]; then
  echo "✅ Docker is installed correctly"
else
  echo "❌ Docker installation failed"
  exit 1
fi

echo "Testing Docker Compose..."
docker compose version
if [ $? -eq 0 ]; then
  echo "✅ Docker Compose is installed correctly"
else
  echo "❌ Docker Compose installation failed"
  exit 1
fi

echo "Creating test network connectivity file..."
cat > /home/ubuntu/devpod/test_network.sh << 'EOF'
#!/bin/bash
# Test internal network connectivity between services

echo "Testing network connectivity between services..."
docker exec -it gitea ping -c 2 drone-server
docker exec -it gitea ping -c 2 code-server
docker exec -it gitea ping -c 2 verdaccio
docker exec -it gitea ping -c 2 pypi
docker exec -it gitea ping -c 2 registry
docker exec -it gitea ping -c 2 authelia

echo "Network connectivity test completed!"
EOF

chmod +x /home/ubuntu/devpod/test_network.sh

echo "===== DevPod Environment Test Completed ====="
echo "To start the environment, run: cd /home/ubuntu/devpod && docker compose up -d"
echo "To test network connectivity after startup, run: /home/ubuntu/devpod/test_network.sh"
