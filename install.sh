#!/usr/bin/env bash

ARCH=$(dpkg --print-architecture)
VERSION=0.9.0
INSTALLDIR=/usr/local/bin
CONFIGDIR=/etc/prometheus

SRC_URL=https://github.com/prometheus/haproxy_exporter/releases/download/v${VERSION}/haproxy_exporter-${VERSION}.linux-${ARCH}.tar.gz

# Download and install the binary.
echo " - Download source from: ${SRC_URL}"
wget -q --show-progress -O- ${SRC_URL} | tar zxf -
sudo mv haproxy_exporter-${VERSION}.linux-${ARCH}/haproxy_exporter ${INSTALLDIR}/haproxy_exporter-${VERSION}

# Create User/Group
echo " - Adding user: haproxy_exporter"
sudo useradd -M -s /bin/false haproxy_exporter

# Write config
echo " - Write config: ${CONFIGDIR}/haproxy_exporter.conf"
sudo mkdir -p ${CONFIGDIR}
sudo cp ./haproxy_exporter.conf ${CONFIGDIR}/

# Write system service file.
echo " - Write systemd service file: /etc/systemd/system/haproxy_exporter.service"
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

echo " - Done"
