#!/usr/bin/env bash

ARCH=$(dpkg --print-architecture)
VERSION=0.9.0
INSTALLDIR=/usr/local/bin
CONFIGDIR=/etc/prometheus

# Download and install the binary.
wget -O- https://github.com/prometheus/haproxy_exporter/releases/download/v${VERSION}/haproxy_exporter-${VERSION}.linux-${ARCH}.tar.gz | tar zxf -
sudo mv haproxy_exporter-${VERSION}.linux-${ARCH}/haproxy_exporter ${INSTALLDIR}/haproxy_exporter-${VERSION}

# Create User/Group
sudo useradd -M -s /bin/false haproxy_exporter

# Write config
sudo mkdir -p ${CONFIGDIR}
sudo cp ./haproxy_exporter.conf ${CONFIGDIR}/

# Write system service file.
echo "[Unit]
Description=HAProxy Prometheus Exporter
Wants=network-online.target
After=network-online.target

[Service]
EnvironmentFile=-${CONFIGDIR}/haproxy_exporter.conf
User=haproxy_exporter
Group=haproxy_exporter
Type=simple
ExecStart=/usr/local/bin/haproxy_exporter-${VERSION} \$HAPROXY_EXPORTER_OPTS

[Install]
WantedBy=multi-user.target" | sudo tee /etc/systemd/system/haproxy_exporter.service > /dev/null
