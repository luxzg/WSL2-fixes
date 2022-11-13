### This file `networkingMode=bridged-ultra-quick.md` is ultimate compressed guide, with just a list of commands and related configs, in cases when you're simply reinstalling WSL or similar, and you know everything on this topic already.
### If you've arrived here from somewhere else, please first read the "full guide" or at least "quick reference" in this same repo (https://github.com/luxzg/WSL2-fixes).

# Command list (in order of execution)

** Terminal - reinstall distro**
```
wsl.exe --help
wsl.exe --shutdown
wsl.exe --unregister Ubuntu
wsl.exe --list --online
wsl.exe --install Ubuntu
```

** Ubuntu - first start **
```
Enter new UNIX username: lux
New password:
Retype new password:
passwd: password updated successfully
Installation successful!
```

** WSL - wsl.conf ***
```
lsb_release -a
sudo nano /etc/wsl.conf
```
** File contents **
```
[boot]
systemd=true
[network]
generateResolvConf = false
```

** WSL - networkd config **
```
sudo nano /lib/systemd/network/wsl_external.network
```

** File contents**
```
[Match]
Name=eth0
[Network]
Description=WSL_external
DHCP=false
Address=192.168.0.93/24
Gateway=192.168.0.1
```

** WSL - exit **
`exit`

** Terminal - .wslconfig **
```
wsl.exe --shutdown
cd ~
.\.wslconfig
```

** File contents **
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

** Terminal - start WSL **
```
wsl.exe -d Ubuntu
```

** WSL - resolved config **
```
sudo su
nano /etc/resolv.conf
```

** File contents **
```
nameserver 8.8.8.8
```

** WSL - services and check **
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

** Terminal - force restart **
```
wsl.exe --shutdown
wsl.exe -d Ubuntu
```

** WSL - check and update **
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

** WSL - optional, Apache (testing) **
```
apt-get install apache2 -y
systemctl enable apache2
systemctl restart apache2
exit
exit
```

** Terminal - force restart (testing) **
```
wsl.exe --shutdown
wsl.exe -d Ubuntu
```

** WSL - optional, WSLg (testing) **
```
sudo su
apt-get install x11-apps -y
xeyes &
xcalc &
exit
```
