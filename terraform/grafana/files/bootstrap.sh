#!/bin/bash

cat << EOF > /etc/yum.repos.d/grafana.repo
[grafana]
name=grafana
baseurl=https://rpm.grafana.com
repo_gpgcheck=1
enabled=1
gpgcheck=1
gpgkey=https://rpm.grafana.com/gpg.key
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
exclude=*beta*
EOF

yum install -y grafana

firewall-offline-cmd --add-port=3000/tcp --zone=public
systemctl restart firewalld

grafana-cli plugins install yesoreyeram-infinity-datasource

systemctl daemon-reload
systemctl enable grafana-server
systemctl start grafana-server

echo "Welcome! I've been bootstrapped by Terraform." >> /etc/motd
