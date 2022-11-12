```
wsl.exe --help
wsl.exe --shutdown
wsl.exe --unregister Ubuntu
wsl.exe --list --online
wsl.exe --install Ubuntu
```

```
Enter new UNIX username: lux
New password:
Retype new password:
passwd: password updated successfully
Installation successful!
```

```
lsb_release -a
sudo nano /etc/wsl.conf
```

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
```

```
# Settings apply across all Linux distros running on WSL 2
[wsl2]

# Bridged networking
networkingMode=bridged
vmSwitch=WSL_external
dhcp=false
macAddress=5c:bb:f6:9e:ee:55
ipv6=true

# Limits VM memory to use no more than 4 GB, this can be set as whole numbers using GB or MB
memory=4GB 

# Sets the VM to use two virtual processors
processors=2

# Turn on/off default connection to bind WSL 2 localhost to Windows localhost ; default is true
localhostforwarding=true

# Turns on/off output console showing contents of dmesg when opening a WSL 2 distro for debugging ; default is false
debugConsole=false

# Turns on/off running GUI apps ; default is true
guiApplications=true
```

```
wsl.exe -d Ubuntu
```

```
sudo su
nano /etc/resolv.conf
```

```
nameserver 8.8.8.8
```

```
systemctl restart systemd-networkd
systemctl enable systemd-networkd
systemctl restart systemd-resolved.service
systemctl enable systemd-resolved.service
ip a
ping www.google.com
exit
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
apt-get update
apt-get upgrade -y
apt-get full-upgrade -y
```

```
apt-get install apache2
systemctl enable apache2
systemctl restart apache2
exit
exit
```

`wsl.exe --shutdown`
