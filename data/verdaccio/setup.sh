# Verdaccio User Setup Script
# This script creates a default user for Verdaccio

#!/bin/bash

# Create htpasswd file if it doesn't exist
mkdir -p /verdaccio/storage

# Create a default user (admin:admin123)
echo "admin:$apr1$l4xdcyxx$Jn/4qOS9bJjxhkAOPyK0C/" > /verdaccio/storage/htpasswd

echo "Verdaccio user setup completed!"
