#!/bin/bash
# PyPI Server Setup Script
# This script creates a default user for PyPI server

# Create htpasswd file if it doesn't exist
mkdir -p /data/packages

# Create a default user (admin:admin123)
echo "admin:$apr1$l4xdcyxx$Jn/4qOS9bJjxhkAOPyK0C/" > /data/packages/.htpasswd

# Create a sample package directory
mkdir -p /data/packages/simple

echo "PyPI server setup completed!"
