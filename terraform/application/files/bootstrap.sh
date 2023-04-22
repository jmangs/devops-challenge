#!/bin/bash

yum install -y jdk1.8
yum config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
yum install -y docker-ce

systemctl enable docker.service
systemctl start docker.service

# TODO: Grab Dropwizard container

echo "Welcome! I've been bootstrapped by Terraform." >> /etc/motd