# SHORT COMMAND LIST
This is WSL2 bridging in really short, as a reference for those that do it repeatedly, and don't want to ready everything.
This is version for those that already have Hyper-V, vSwitch, and want Ubuntu distro with systemd networking.
For full tutorial please go here: https://github.com/luxzg/WSL2-fixes/blob/master/networkingMode%3Dbridged.md

If you haven't EVER setup WSL2 with systemd and bridged networking - please read full file.

If you need more information about commands and configurations mentioned in this guide - pleas read full file.

# Install WSL 2 Preview
To get latest updates and features, including virtual switch bridging you NEED the latest Preview version and need to get it from Microsoft Store

- Official link to WSL on Store
https://aka.ms/wslstorepage
Just click GET to install

# Install WSL distro, this is for Ubuntu

- Install WSL 2 distro according to your preferences, eg Ubuntu from Microsoft Store
https://www.microsoft.com/en-us/p/ubuntu/9pdxgncfsczv
Again just click GET, and then be patient, ~670 MB download

# Post-install steps

- In elevated PowerShell / Terminal prompt (run as Administrator)
- Update WSL installation (just in case)
`wsl --update`
- Close WSL for now
`wsl --shutdown`

# Create WSL configuration file with correct settings

- In elevated PowerShell prompt, continued
```
cd ~
New-Item .wslconfig
.\.wslconfig
```
- Select your choice of text editor to open file
- If you forgot what was your virtual switch named run this in PowerShell
`Get-VMSwitch -SwitchType External`

### Inside text editor

- Now add to your .wslconfig file text like this
```
[wsl2]
networkingMode=bridged
vmSwitch=WSL_external
dhcp=false
ipv6=true
```
- To clarify: `vmSwitch=` line defines connection to External Virtual Switch from Hyper-V and needs name of that same switch
- See full guide file for optional lines like `macAddress=` or in depth explanation of other options
- Save and close the file

### VERY IMPORTANT !!! I have seen several posts that made typos in config, if the tutorial "doesn't work" please make sure you check wslconfig and use COPY PASTE !!!

# WSL distro first run

- Now you can run and install your distribution
- Change name according to what you've installed from Microsoft Store earlier
	- Start menu -> Ubuntu
- It will open first time GUI setup so run with it
- Pick language, Next, enter your name, username and password (2x)
	- Note: I had issues because apparently you can't use non latin characters in your name
- Keep pressing Continue / Next / Setup, and so on, ... and Finish

# Starting and updating your WSL2 distro

- In Terminal / PowerShell
- Listing all distros
`wsl --list -v`
- Updating distros if you haven't already
`wsl --update`
- Starting distros (eg, start Ubuntu)
`wsl -d Ubuntu`

# systemd setup and check
`systemd` is default in many distributions right now, so we'd want to use that too to be as close "to the real thing" as possible.

- From inside WSL prompt we need to configure `wsl.conf` file for `systemd` usage, so edit the file
`sudo nano /etc/wsl.conf`
- Copy paste following into the file
```
[boot]
systemd=true
[network]
generateResolvConf = false
```
- Exit nano editor and save the file
`CTRL+X to close, and Y to confirm save over same filename`
- Shut down WSL instance by running these commands inside active WSL distro prompt
```
exit
wsl --shutdown
```

- Start your WSL instance again, eg.
`wsl -d Ubuntu`
- We can check if systemd is working by running this in the WSL prompt:
`systemctl list-unit-files --type=service`

- Note: there have been reports that enabling systemd on existing WSL2 instance can make it stop responding altogether, but simple fix is to reboot the whole host PC, doing just WSL restart wasn't enough, but after reboot everything worked as expected

# Completely client-side networking with systemd related services

### Now we need to configure networking inside WSL OS, because we've lost the help from WSL (sub)system itself, so let's dig in!

- Get root
`sudo su`
- Confirm that you don't have any networking
`ip a`
- You will see something like this, `eth0` with MAC but no IP address assigned
```
	6: eth0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
		link/ether 5c:bb:f6:9e:ee:fa brd ff:ff:ff:ff:ff:ff
```
- To fix this go to directory in which Ubuntu keeps networking configs (if you use different OS you'll need to dig deeper, see reference links at the end of the full guide file)
`cd /lib/systemd/network/`
- Create and edit a new file
`nano wsl_external.network`
- Contents of the file (use copy/paste)
```
[Match]
Name=eth0

[Network]
Description=WSL_external
DHCP=true
IPv6AcceptRA=true
MulticastDNS=true
LLDP=true
EmitLLDP=true

[DHCP]
CriticalConnection=true
RouteMetric=10
UseDomains=true
```
- Explanation
	- `eth0` is name of the interface
	- `Description` is whatever you want it to be
	- `DHCP=true` tells the networking stack to use DHCP, so automatic IP assignment via local router
	- `IPv6AcceptRA=true` is to allow IPv6
	- (for rest see official docs, linked at the end of full guide file)
- In short - this config is for obtaining IP address automatically via DHCP service, including working IPv6
- You can also use `DHCP=false` then in `[Network]` section set the static `Address=x.x.x.x/24` and `Gateway=x.x.x.x` (using actual valid, available and free IP for Address and valid gateway for, well, gateway), see full guide file for details

- Save and close the file
```
CTRL+X
	Y
```
- Restart the networking service
`systemctl restart systemd-networkd`
- And make sure it's enabled for future auto-start on WSL start
`systemctl enable systemd-networkd`
- Check if you've got IP now
`ip a`
- You should see both IPv4 and IPv6 addresses on `eth0` interface !
```
	6: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
		link/ether 5c:bb:f6:9e:ee:fa brd ff:ff:ff:ff:ff:ff
		inet 192.168.0.34/24 metric 10 brd 192.168.0.255 scope global eth0
		   valid_lft forever preferred_lft forever
		inet6 fe80::5ebb:f6ff:fe9e:eefa/64 scope link
		   valid_lft forever preferred_lft forever
```

One more thing we need to configure is DNS resolving, as at this point you can only ping an IP eg. `8.8.8.8` but not FQDN like `google.com`:

- We've already added `generateResolvConf = false` to `wsl.conf` telling WSL to NOT generate `resolv.conf` anymore, so now we have to generate it manually
- Edit `resolv.conf` with `nano`
`nano /etc/resolv.conf`
- Contents
`nameserver 8.8.8.8`
- Save and close file
```
CTRL+X
	Y
```
- Restart service
`systemctl restart systemd-resolved.service`
- And make sure it is enabled for future auto-start
`systemctl enable systemd-resolved.service`
- Test resolving by simply pinging some FQDN, eg.
`ping google.com`

# Final test - reboot
Final test is to see if everything works after restart of everything - WSL and the whole host PC!

- Shutdown WSL instance
```
exit
exit
wsl --shutdown
```
- Reboot your whole PC
- NOTE: you may need to start your WiFi or connect that physical cable to adapter of choice
	- I had that issue exactly as I have multiple adapters on my PC (any I keep forgetting to connect them when needed)
- Start WSL instance, eg.
`wsl -d Ubuntu`
- Check from inside WSL with:
```
ip a
networkctl status eth0
ping 1.1.1.1
ping google.com
```

# WSL distro updating of OS - Ubuntu

- Now check for and run updates in WSL distro
	- btw "sudo" to get root rights (this is equivalent of Run as Admin in Windows)
```
sudo su
	<password>
```
- Then run apt commands to update and upgrade everything
```
apt update
apt upgrade
	y
apt full-upgrade
	y
```

# VERY OPTIONAL! Endgame testing
Here we will install Apache server, enable service with systemd, reboot PC, and see if it's still working once WSL distro starts.
This confirms working networking, working incoming networking, working networking even after reboot, "stability" of `resolv.conf`, and working `systemd` services.

- Command to install server, make sure you're still running as sudo (root), if not - you'll need to repeat `sudo su` as before then run the install command: 
`apt install apache2`
- Restart and check status of apache2 service
```
service apache2 restart
service apache2 status
```
- Check if apache2 is listening on ports as you'd expect with command :
`lsof -i -P -n | grep LISTEN`
- You can now also setup Apache to always run by enabling the service autostart, this is also good test if `systemd` is actually working, command is :
`sudo systemctl enable apache2`

### Check if webpage is available from 3rd PC/smarphone by trying http://x.x.x.x/ (your WSL IP) in browser, and if it is, shutdown WSL, reboot PC, start WSL distro (only start it!), and check that webpage again from 3rd device - it should still work, without manual start! Also note that using either IP or localhost should work from Windows host PC.

- If you don't need/want to keep Apache you can remove it now as well
- To remove Apache installation run:
```
apt remove apache2
	y
```

### That's it!