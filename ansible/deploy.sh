#!/bin/bash

set -e

echo "🚀 Starting deployment..."

echo "📋 Running Ansible playbook..."
ansible-playbook -i inventory.ini playbook.yml \
    -e mysql_root_password="${MYSQL_ROOT_PASSWORD:-changeme123}" \
    -e mysql_database="${MYSQL_DATABASE:-goapp}" \
    -e mysql_user="${MYSQL_USER:-gouser}" \
    -e mysql_password="${MYSQL_PASSWORD:-gopassword}"

echo "🔄 Restarting application service..."
ansible webrtc_vm -i inventory.ini -m systemd -a "name=go-app state=restarted" --become

echo "🏥 Performing health check..."
sleep 10
HOST=$(grep -A1 "\[go_server\]" inventory.ini | tail -1 | awk '{print $1}')
curl -f "http://${HOST}:8080/health" || echo "⚠️  Health check failed - check application logs"

echo "✅ Deployment complete!"