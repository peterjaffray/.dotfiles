echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf
echo "net.ipv6.conf.default.disable_ipv6 = 1" >> /etc/sysctl.conf
echo "net.ipv6.conf.lo.disable_ipv6 = 1" >> /etc/sysctl.conf
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
sysctl -p

# Disable IPv6 in GRUB
sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="quiet"/GRUB_CMDLINE_LINUX_DEFAULT="quiet ipv6.disable=1"/g' /etc/default/grub
update-grub

# Disable IPv6 in SSH
echo "AddressFamily inet" >> /etc/ssh/sshd_config

echo ' {
    "insecure-registries" : ["localhost:32000"]
}' > /etc/docker/daemon.json

