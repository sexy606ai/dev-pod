# Code Server Setup Script
# This script will be run when code-server container starts
# It installs recommended extensions and sets up the environment

#!/bin/bash

# Create workspace directory if it doesn't exist
mkdir -p /home/coder/workspace

# Install extensions from the extensions.txt file
if [ -f /home/coder/extensions.txt ]; then
  while read extension; do
    # Skip comments and empty lines
    [[ $extension =~ ^#.*$ ]] && continue
    [[ -z $extension ]] && continue
    
    echo "Installing extension: $extension"
    code-server --install-extension $extension
  done < /home/coder/extensions.txt
fi

# Create a welcome file
cat > /home/coder/workspace/WELCOME.md << EOF
# Welcome to DevPod Code Server

This is your browser-based VS Code environment, fully integrated with the DevPod stack.

## Available Services

- **Gitea**: [http://gitea.localhost](http://gitea.localhost) - Git repositories
- **Drone CI**: [http://drone.localhost](http://drone.localhost) - CI/CD pipelines
- **Verdaccio**: [http://npm.localhost](http://npm.localhost) - NPM registry
- **PyPI**: [http://pypi.localhost](http://pypi.localhost) - Python package registry
- **Docker Registry**: [http://registry.localhost](http://registry.localhost) - Container registry

## Getting Started

1. Clone a repository from Gitea
2. Create a new project
3. Set up CI/CD with Drone
4. Publish packages to the registries

Happy coding!
EOF

echo "Code Server setup completed!"
