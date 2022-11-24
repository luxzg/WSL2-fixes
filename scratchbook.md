# To remember stuff I need sometimes on WSL

### Reinstall Ubuntu distro without download

- `wsl.exe --unregister Ubuntu`
- `wsl.exe --install Ubuntu`
- will start new instance:
  - Enter new UNIX username:
  - New password:
  - Retype new password:
  - passwd: password updated successfully
  - Installation successful!
- configure `wsl.network` and `wsl.conf` and restart distro

### nmap + GUI

- `apt install nmap`
- `apt install nmapsi4`
- `nmapsi4 &`

Links:

- https://nmap.org/
- https://github.com/nmapsi4/nmapsi4
  - GUI for nmap, works on WSL2

### kdenlive - GUI video editor

- `apt instal kdenlive`

Links:

- https://kdenlive.org/en/

### LAMP on 20.04

- `pt install apache2`
- `apt install mysql-server`
- `mysql_secure_installation`
- `mysql -u root -p`
- `SHOW DATABASES;`
- `apt install php libapache2-mod-php php-mysql`
- `nano /etc/apache2/sites-available/000-default.conf`
- `a2ensite 000-default`
- `systemctl reload apache2`
- `nano /var/www/index.php`
- `<?php phpinfo(); ?>`

Links:

- https://www.digitalocean.com/community/tutorials/how-to-install-linux-apache-mysql-php-lamp-stack-on-ubuntu-20-04

### NetworkManager & GUFW - GUI

- GUI frontends for NetworkManager (network settings)
- GUI frontend for UFW (firewall)

Links:

- http://gufw.org/
- https://askubuntu.com/questions/174381/openning-networkmanagers-edit-connections-window-from-terminal

```
apt-get install gufw -y
gufw &
apt-get install network-manager-gnome -y
nm-connection-editor &
```

### NetPlan, NetworkManager, GUI - networking
This is just for people wanting to use NetPlan and NetworkManager, eg. if they have lots of VPNs etc.

- you first need networking to work in any way (see guides) so you can use `apt` to install new packages
- once you have working connection run these commands in WSL:
```
sudo su
  <password>
apt install network-manager
apt install network-manager-gnome
```
- with packages installed we need to reconfigure networking, if you've used `systemd` guide that means deleting some files, and creating new ones
- we create one empty files to let NetworkManager know it will manage connections
- we remove old `.network` config that contains `networkd` configuration
- we remove old `resolv.conf` that was manually created to manage DNS (nameservers)
- we create link to new resolved stub allowing it to manage DNS behind the scenes
- we create actual NetPlan config (DHCP, later we can change this in GUI)
```
touch /etc/NetworkManager/conf.d/10-globally-managed-devices.conf
rm /lib/systemd/network/wsl_external.network
rm /etc/resolv.conf
ln -s /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
nano /etc/netplan/01-netcfg.yaml
```
- `.yaml` file contents, the following is YAML and it is very sensitive to spacing, use copy paste
```
network:
  renderer: NetworkManager
  ethernets:
    eth0:
      dhcp4: yes
  version: 2
```
- tell NetworkManager it may manage connections, edit file, change `managed=false` to `managed=true` in this file
```
nano /etc/NetworkManager/NetworkManager.conf
```
- apply all settings and enable all services, then show `eth0` settings
```
systemctl enable NetworkManager
systemctl restart NetworkManager
netplan apply
ip a
nmcli device show eth0
```
- `nmcli` on my WSL instance showed this (DHCP assigned)
```
GENERAL.DEVICE:                         eth0
GENERAL.TYPE:                           ethernet
GENERAL.HWADDR:                         5C:BB:F6:9E:EE:55
GENERAL.MTU:                            1500
GENERAL.STATE:                          100 (connected)
GENERAL.CONNECTION:                     netplan-eth0
GENERAL.CON-PATH:                       /org/freedesktop/NetworkManager/ActiveConnection/1
WIRED-PROPERTIES.CARRIER:               on
IP4.ADDRESS[1]:                         192.168.0.34/24
IP4.GATEWAY:                            192.168.0.1
IP4.ROUTE[1]:                           dst = 0.0.0.0/0, nh = 192.168.0.1, mt = 100
IP4.ROUTE[2]:                           dst = 192.168.0.0/24, nh = 0.0.0.0, mt = 100
IP4.DNS[1]:                             178.17.127.131
IP4.DNS[2]:                             1.1.1.1
IP4.DNS[3]:                             8.8.4.4
IP4.DOMAIN[1]:                          cable.btnet.hr
IP6.ADDRESS[1]:                         fe80::5ebb:f6ff:fe9e:ee55/64
IP6.GATEWAY:                            --
IP6.ROUTE[1]:                           dst = fe80::/64, nh = ::, mt = 256
```
- you can now setup static IP with GUI tools installed earlier
```
nm-connection-editor &
```
- I've used GUI to delete manually created DHCP config, created new config, used `eth0`, assigned static IP, static DNS, etc.
- Save changes in GUI, and then close GUI Network Manager, it should automatically apply new settings to your network interface
- now check network status, it should show new settings applied
- `ip a` output
```
ip a

1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: bond0: <BROADCAST,MULTICAST,MASTER> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether ae:07:24:09:46:9d brd ff:ff:ff:ff:ff:ff
3: dummy0: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 06:4f:f8:55:f3:69 brd ff:ff:ff:ff:ff:ff
4: tunl0@NONE: <NOARP> mtu 1480 qdisc noop state DOWN group default qlen 1000
    link/ipip 0.0.0.0 brd 0.0.0.0
5: sit0@NONE: <NOARP> mtu 1480 qdisc noop state DOWN group default qlen 1000
    link/sit 0.0.0.0 brd 0.0.0.0
6: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether 5c:bb:f6:9e:ee:55 brd ff:ff:ff:ff:ff:ff
    inet 192.168.0.92/24 brd 192.168.0.255 scope global noprefixroute eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::76ed:7355:f46e:9072/64 scope link noprefixroute
       valid_lft forever preferred_lft forever
```
- `nmcli device show eth0` output
```
nmcli device show eth0

GENERAL.DEVICE:                         eth0
GENERAL.TYPE:                           ethernet
GENERAL.HWADDR:                         5C:BB:F6:9E:EE:55
GENERAL.MTU:                            1500
GENERAL.STATE:                          100 (connected)
GENERAL.CONNECTION:                     Ethernet connection 1
GENERAL.CON-PATH:                       /org/freedesktop/NetworkManager/ActiveConnection/2
WIRED-PROPERTIES.CARRIER:               on
IP4.ADDRESS[1]:                         192.168.0.92/24
IP4.GATEWAY:                            192.168.0.1
IP4.ROUTE[1]:                           dst = 192.168.0.0/24, nh = 0.0.0.0, mt = 100
IP4.ROUTE[2]:                           dst = 0.0.0.0/0, nh = 192.168.0.1, mt = 100
IP4.DNS[1]:                             8.8.8.8
IP4.DNS[2]:                             8.8.4.4
IP6.ADDRESS[1]:                         fe80::76ed:7355:f46e:9072/64
IP6.GATEWAY:                            --
IP6.ROUTE[1]:                           dst = fe80::/64, nh = ::, mt = 1024
```
- notice that IP and DNS show new values
- restarting should keep everything running as is automatically
