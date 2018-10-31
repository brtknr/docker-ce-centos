setenforce 0
systemctl stop docker
systemctl disable docker
atomic install --system --system-package no --name docker docker.io/brtknr/docker-ce:18.06
systemctl daemon-reload
systemctl enable docker
systemctl start docker
