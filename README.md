
# HAProxy Exporter systemd

This project contains a simple bash script that installs [prometheus/haproxy_exporter
](https://github.com/prometheus/haproxy_exporter/) and also a basic systemd service file.


## Install

Just do `./install.sh` and everything should be installed.


## Configuration

Configuration for the exporter can be found at `/etc/prometheus/haproxy_exporter.conf`.
it is highly recommended to look at this file and configure the exporter before starting the
service.


## Starting the service

Start the service by issuing the standard systemd command:
```
$ sudo systemctl start haproxy_exporter
```

And to make it start at boot:

```
$ sudo systemctl enable haproxy_exporter
```

run `man systemd` for more information.
