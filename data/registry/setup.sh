#!/bin/bash
# Docker Registry Setup Script
# This script creates authentication for Docker Registry

# Create auth directory if it doesn't exist
mkdir -p /auth

# Create a default user (admin:admin123)
htpasswd -Bbn admin admin123 > /auth/htpasswd

echo "Docker Registry setup completed!"
