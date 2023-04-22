#!/bin/bash

yum install -y jdk1.8
yum config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
yum install -y docker-ce

systemctl enable docker.service
systemctl start docker.service

docker pull jmangs/oci-devops-challenge

cat << EOF > /etc/systemd/system/docker.dropwizard.service
[Unit]
Description=Dropwizard Container
After=docker.service
Requires=docker.service

[Service]
TimeoutStartSec=0
Restart=always
ExecStartPre=-/usr/bin/docker stop %n
ExecStartPre=-/usr/bin/docker rm %n
ExecStartPre=/usr/bin/docker pull jmangs/oci-devops-challenge
ExecStart=/usr/bin/docker run --rm --name %n -p 8080:8080 -p 8081:8081 jmangs/oci-devops-challenge

[Install]
WantedBy=multi-user.target
EOF

systemctl enable docker.dropwizard.service
systemctl start docker.dropwizard.service

echo "Welcome! I've been bootstrapped by Terraform." >> /etc/motd
