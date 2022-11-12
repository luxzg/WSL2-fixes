```
wsl.exe --help
wsl.exe --shutdown
wsl.exe --unregister Ubuntu
wsl.exe --list --online
wsl.exe --install Ubuntu
```

`lsb_release -a`
`sudo nano /etc/wsl.conf`

```
[boot]
systemd=true
[network]
generateResolvConf = false
```

`sudo nano /lib/systemd/network/wsl_external.network`

```
[Match]
Name=eth0
[Network]
Description=WSL_external
DHCP=false
Address=192.168.0.93/24
Gateway=192.168.0.1
```

`exit`

```
wsl.exe --shutdown
cd ~
.\.wslconfig
wsl.exe -d Ubuntu
```

```
sudo nano /etc/resolv.conf
systemctl restart systemd-networkd
systemctl enable systemd-networkd
systemctl restart systemd-resolved.service
systemctl enable systemd-resolved.service
ip a
ping www.google.com
exit
```

```
wsl.exe --shutdown
wsl.exe -d Ubuntu
```

```
ip a
ping google.com
ping www.google.com
ping www.bing.com
sudo su
```
