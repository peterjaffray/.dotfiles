echo >/etc/systemd/resolved.conf "\
[Resolve]
DNS=10.0.1.10
FallbackDNS=10.0.1.1
Domains=choice.zone"
systemctl restart systemd-resolved