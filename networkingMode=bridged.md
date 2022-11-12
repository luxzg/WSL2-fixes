Originally posted here:
https://github.com/microsoft/WSL/issues/4150#issuecomment-1288152162

# ABOUT THIS TUTORIAL
OK folks, after many years watching WSL space, then another year watching at WSL on W11 from the bench (W10 PC) I finally got up to date.
Since I see many questions I've decided to write a little bit expanded tutorial for this thread.

# REQUIREMENTS

-  Windows 11 Pro license
 	- please, this is available everywhere and cheap, and offers so much more than just easier WSL networking, if you're a PRO then buy a PRO !
-  64 bit PC with 64-bit UEFI BIOS
 	- W11 will NOT run on 32bit hardware, and also some mini PCs and tablets that have 64bit Atom sometimes have 32bit UEFI so those won't work either, I tried
-  Internet connection
 	- to download tools, Windows installation, WSL installation, WSL distro, and everything else
-  Optional: USB stick
 	- only if you need to upgrade from W10 on unsupported hardware
-  ... time

# For poor folks that are on the bench

-  Install Windows 11 Pro
 	- if not allowed by Microsoft then use Rufus to create bootable USB stick that allows installation on any x64 CPU without the need to have TPM, certain CPU model, and so on
- If you've been stuck on W10 for a year waiting for something to happen - stop waiting!
- Not to promote any external tools, but MS did it to themselves:
 	- https://pureinfotech.com/rufus-create-bootable-windows-11-22h2-usb/
- This link will tell you where to get Rufus, how to use it to download W11 ISO, how to create bootable USB stick, how to remove the 4GB, Secure Boot, TPM and CPU model limitations (see the section about unsupported hardware)
- Then you can use this USB to boot fresh install, or run the setup from that USB from inside W10 to upgrade in place
- There's some more work for when language of W10 and W11 installation differ, if you stumble upon that msg me, those instructions are beyond the scope of this overal tutorial

# WSL 2 with proper networking
This section is large, so just be patient and follow steps

### After you're in W11 PRO - update Windows 11 fully

- Use Windows Update AND Microsoft Store, update everything
- This is no longer limited to Insider builds, I am running W11 PRO 22H2 (stable) and this tutorial was made on that version

### OPTIONAL: Install and use Microsoft Terminal
I did this tutorial using Terminal, but in reality all commands run via usual cmd or PowerShell so if you want skip this, just make sure to use PowerShell prompt instead

- Official link to Terminal on Microsoft Store, just click and install
https://aka.ms/terminal

# Install Hyper-V features and tools
Open cmd or PowerShell or Terminal as Administrator (eg right click on Start and pick "Terminal (Admin)") and run the rest of commands in elevated prompts - ALWAYS!

### Check system info
`systeminfo`

- Check if your virtualization is enabled in BIOS / UEFI firmware under "Hyper-V Requirements"
- Also check that you have Windows 11 Pro under "OS Name"

# Have the Virtual Machine Platform optional component enabled

- You can do this by running the following command in an elevated prompt
`DISM /Online /Enable-Feature /All /FeatureName:Microsoft-Hyper-V /all`
- You will see something like:
```
	The operation completed successfully.
	Restart Windows to complete this operation.
	Do you want to restart the computer now? (Y/N)
```
- Restart your PC
`Y`

# OPTIONAL : updating WinGet and PowerShell to latest stable versions
This is really optional, as W11 is shipped with PowerShell and winget by default and both are relatively recent if you've used Windows Update to the fullest (W11 22H2)

- From elevated Terminal (Admin) prompt:
	- update all packages using winget
	- !! WARNING !! : this will update other applications as well (!!) so you can skip this line
`winget upgrade --all`
- Check current PowerShell version
`(Get-Host).Version`
- Find PowerShell in winget repository
`winget search Microsoft.PowerShell`
- Now you know current and latest available versions, so if you want the latest one then...
	- Install latest stable PowerShell using winget
`winget install --id Microsoft.Powershell --source winget`
- Check versions after install
`(Get-Host).Version`
(it should be one that winget installed)
- Also check winget version if you get stuck and need troubleshooting
`winget -v`

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

- Update WSL installation
`wsl --update`
- And get current versions
`wsl --version`
- Will respond with something like this:
```
WSL version: 0.70.0.0
Kernel version: 5.15.68.1
WSLg version: 1.0.45
MSRDC version: 1.2.3575
Direct3D version: 1.606.4
DXCore version: 10.0.25131.1002-220531-1700.rs-onecore-base2-hyp
Windows version: 10.0.22621.675
```
- NOTE! If `--version` does not work you probably DO NOT have Preview version from Microsoft Store installed !!
- Close WSL for now
`wsl --shutdown`

# Creating Virtual Switch in Hyper-V Manager

- Run Hyper-V Manager
	- On the left select your PC
	- On the right select Virtual Switch Manager
	- Inside manager select "New virtual network switch"
	- On the right select "External"
	- Then click Create Virtual Switch
	- Under "Name:" enter distinctive name, eg "WSL_external"
	- Make sure to select exact physical adapter (WiFi, LAN, etc) and since this is most likely your only adapter, have checkbox checked under "Allow management operating system to share this network adapter"
	- Apply, Yes, OK

This can also be done in PowerShell but I figure GUI is more user friendly, see links at the bottom for reference article with pictures

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
```
- To clarify:
`vmSwitch=`
- Defines connection to External Virtual Switch from Hyper-V and needs name of same switch
- Also more options were added in later versions, but we DO NOT use them
```
 	macAddress
 	dhcp
 	dhcpTimeout
 	ipv6
```
- Save and close the file

### VERY IMPORTANT !!! I have seen several posts that made typos in config, if the tutorial "doesn't work" please make sure you check wslconfig and use COPY PASTE !!!

# WSL distro first run

- Now you can run and install your distribution
- Change name according to what you've installed from Microsoft Store earlier
	- Start menu -> Ubuntu
- It will open first time GUI setup so run with it
- Pick language, Next, enter your name, username and password (2x), Next, Continue
	- Note: I had issues because apparently you can't use non latin characters in your name
- Continue, Apply, and so on, Finish

# Starting and updating your WSL2 distro

- In Terminal / PowerShell
- Listing all distros
`wsl --list -v`
- Updating distros
`wsl --update`
- Starting distros (eg, start Ubuntu)
`wsl -d Ubuntu`

# Checking networking

- Now check your IP and IP of your WSL distro in Terminal, use a separate window/tab for each
- Your Windows 11 config
`ipconfig`
- Examples from me
```
LAN
IPv4 Address. . . . . . . . . . . : 192.168.0.26
WiFi vEthernet
IPv4 Address. . . . . . . . . . . : 192.168.0.24
Default switch (that annoying one that changes IP)
IPv4 Address. . . . . . . . . . . : 172.24.64.1
```
- For WSL distro run inside distro, if Ubuntu then this is the command
`ip a`
- Should be only one
`inet 192.168.0.33/24 brd 192.168.0.255 scope global eth0`
- NOTE: some distros use ifconfig or other commands

So my WiFi, LAN, AND distro IPs are all different, and assigned by REAL router on my network !!
And most important my distro does NOT have that weird 172.24..... IP of "Default switch"

- You can check pinging outside IP or domain name to verify connectivity and DNS resolving
```
ping 1.1.1.1
ping google.com
```
- Shutting down distro and starting it up again should keep the same IP, eg.
```
exit
wsl --shutdown
wsl -d Ubuntu
ip a
```

# WSL distro updating of OS - Ubuntu

- You will want to update your distro, for Ubuntu this is the usual way
```
sudo apt update
sudo apt upgrade
exit
```
- NOTE: in case update/upgrade failed, you may need to start your WiFi or connect that physical cable to adapter of choice
	- I had that issue exactly as I have multiple adapters on my PC
- Now check for and run updates again in WSL
	- Btw "sudo" to get root rights (this is equivalent of Run as Admin in Windows)
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
- Checking Ubuntu version
`lsb_release -a`
- Using default "Ubuntu" Store distro I get this at the moment, fully updated and so on
```
	root@DESKTOP-123456:/mnt/c/Users/myuser# lsb_release -a
	No LSB modules are available.
	Distributor ID: Ubuntu
	Description:    Ubuntu 22.04.1 LTS
	Release:        22.04
	Codename:       jammy
```

# WSL GUI apps

- We can also install and test some simple GUI apps for WSL
`apt install x11-apps`
- Test them by running
```
xeyes &
xcalc &
```
- If they run fine, close them on "X"

# VERY OPTIONAL! DO NOT RUN if you want to keep your distro clean

- Though it's nothing dangerous, we're just installing web server and opening port 80 to it, and if you want we also remove it at the end
- To confirm networking works for incoming traffic we will install a web server (Apache) and try to access it from outside device eg from mobile phone on same WiFi, or another PC in same LAN
- Command to install server, make sure you're still running as sudo (root) if not you'll need to repeat "sudo su" as before
`apt install apache2`
- Restart and check status of apache2 service
```
service apache2 restart
service apache2 status
```
- Allow listening on port 80 through iptables
	- If you use other port change accordingly
`iptables -I INPUT -p tcp -m tcp --dport 80 -j ACCEPT`
- Check if apache2 is listening on ports as you expected
`lsof -i -P -n | grep LISTEN`
- And try it out! using 3rd device browser type:
http://192.168.0.33
- Make sure you enter IP that's shown in your WSL distro's "ip a" command
- It should show a web page saying something like "Ubuntu, it works, welcome" etc.
- Apache will NOT run automatically on distro reboot (shutdown and re-run) so if you want to continue using Apache you'll need to run the service again eg.
`sudo service apache2 start`
- If you have setup systemd (optional, see below) you can also setup Apache to always run by enabling the service autostart, this is also good test if systemd is actually working
`sudo systemctl enable apache2`
- But everything else is outside of this tutorial, and if you don't need/want apache you can remove it now as well
- To remove apache installation run:
```
apt remove apache2
	y
```
- To remove iptables entry run same as before except -D (-I insert vs. -D delete)
`iptables -D INPUT -p tcp -m tcp --dport 80 -j ACCEPT`

# Conclusion
### THAT'S IT FOLKS!

- You have Ubuntu in WSL2, proper networking, in and out of VM
- You have DHCP from your router (or corporate network)
- You have local WSLg GUI apps if needed working fine, as intended

# NOTES

- If you use VPN - you can now start VPN directly from your WSL distro
- If you often switch between multiple network adapters eg WiFi and LAN you could create New-NetSwitchTeam
- If you are still stuck on Windows 10 or 11 on Home version please go get a W11 PRO key for <10$

# References and links:
### (I have collected links to almost every command in this tutorial, not counting the testing section, if you want to learn more start reading!)

- GitHub issue asking for Hyper-V External adapters on WSL 2:
	- https://github.com/microsoft/WSL/issues/5835
- GitHub comment that discovered the hidden feature:
	- https://github.com/microsoft/WSL/issues/4150#issuecomment-1018524753
	- ghost commented on Jan 21 -> (MANY THANKS TO GHOST!)
- GitHub comment that reported about other new networking features:
	- https://github.com/microsoft/WSL/issues/4150#issuecomment-1031407472
	- these options have been added at 0.51
- Blog post about WSL Preview on Microsoft Store:
	- https://devblogs.microsoft.com/commandline/a-preview-of-wsl-in-the-microsoft-store-is-now-available/
- Official link to WSL on Microsoft Store:
	- https://aka.ms/wslstorepage
- Official instructions for installing Terminal app:
	- https://learn.microsoft.com/en-us/windows/terminal/install
- Official link to Terminal on Microsoft Store:
	- https://aka.ms/terminal
- Official winget upgrade instructions:
	- https://learn.microsoft.com/en-us/windows/package-manager/winget/upgrade
- Official instructions to install PowerShell, recommended way is using winget:
	- https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows?view=powershell-7.2
- Official Ubuntu instructions for WSL for latest Ubuntu with GUI:
	- https://ubuntu.com/tutorials/install-ubuntu-on-wsl2-on-windows-11-with-gui-support#1-overview
- Tutorial for enabling Hyper-V features on Windows 11 (GUI, DISM, and PowerShell):
	- https://www.technewstoday.com/hyper-v-windows-11/
- Official WSL quick help for basic command options:
	- https://learn.microsoft.com/en-us/windows/wsl/basic-commands
- Official instructions for creating Hyper-V External switch (with pictures):
	- https://learn.microsoft.com/en-us/windows-server/virtualization/hyper-v/get-started/create-a-virtual-switch-for-hyper-v-virtual-machines
- Official PowerShell Get-VMSwitch commandlet instructions:
	- https://learn.microsoft.com/en-us/powershell/module/hyper-v/get-vmswitch?view=windowsserver2022-ps
- DigitalOcean instructions for installing LAMP Stack on Ubuntu 22.04 (Apache, MySQL, PHP):
	- https://www.digitalocean.com/community/tutorials/how-to-install-linux-apache-mysql-php-lamp-stack-on-ubuntu-22-04
- Official blog post - Systemd support is now available in WSL:
	- https://devblogs.microsoft.com/commandline/systemd-support-is-now-available-in-wsl/
	- (or) https://aka.ms/wslsystemd
- Using iptables inside Ubuntu to allow ingress traffic:
	- https://docs.rackspace.com/support/how-to/allow-web-traffic-in-iptables/
- Creating bootable USB stick with Rufus and circumventing Windows 11 restrictions:
	- https://pureinfotech.com/rufus-create-bootable-windows-11-22h2-usb/

Edit 72 or whatever:
I have fixed `systemd` related config that I've missed late last night, the `systemd=true` goes to `wsl.conf` not in `.wslconfig`, sorry.

The following 2 sections are describing how to enable and configure `systemd` and related networking services.

# OPTIONAL: systemd setup and check
`systemd` is default in many distributions right now, so we'd want to use that too to be as close "to the real thing" as possible.

- This is NOT needed for working networking, but I do recommend it as eg. Ubuntu usually uses `systemd` by default
- From inside WSL prompt we need to configure `wsl.conf` file for `systemd` usage, so edit the file
`sudo nano /etc/wsl.conf`
- Copy paste following into the file
```
[boot]
systemd=true
```
- Exit nano editor and save the file
`CTRL+X to close, and Y to confirm save over same filename`
- Shut down WSL instance by running these commanda inside active WSL distro prompt
```
exit
exit
wsl --shutdown
```

- Start your WSL instance again, eg.
`wsl -d Ubuntu`
- We can check if systemd is working by running this in the WSL prompt:
`systemctl list-unit-files --type=service`

With `systemd` enabled you should have networking working as earlier.
But if you want to step away from WSL's helping hand completely, have full DHCP / IP v4 / IP v6 controll from inside Linux distro, and so on - then we need few more tweaks. Check next section!

# Completely client-side networking with systemd related services

- Start Terminal or PowerShell in elevated prompt as before
- Stop WSL
`wsl --shutdown`
- Edit config file
```
cd ~
.\.wslconfig
```
- Full contents (added `dhcp=false`)
```
[wsl2]
networkingMode=bridged
vmSwitch=WSL_external
dhcp=false
```
- `dhcp=false` will disable WSL "helper" (WSL’s own DHCP service) that usually assigns IP address, and will let the OS inside WSL instance do all the work
- Save config file and exit text editor

### Now we need to configure networking inside WSL OS, because we've lost the help from WSL (sub)system itself, so let's dig in!

- Still in that elevated prompt, start WSL again, eg.
`wsl -d Ubuntu`
- Get root
`sudo su`
- Confirm that you've just lost your networking
`ip a`
- You will see something like this, `eth0` with MAC but no IP address assigned
```
	6: eth0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
		link/ether 5c:bb:f6:9e:ee:fa brd ff:ff:ff:ff:ff:ff
```
- To fix this go to directory in which Ubuntu keeps networking configs (if you use different OS you'll need to dig deeper, see reference links at the end of this section)
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
	- (For rest see official docs, linked at the end of this section)
- In short - this config is for obtaining IP address automatically via DHCP service, including working IPv6

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

From this point you can edit that same file and add static IP if you wish. We will do that in next section, but... !

One more thing we need to configure is DNS resolving, as at this point you can only ping an IP eg. `8.8.8.8` but not FQDN like `google.com`:

- So let's tell WSL not to handle DNS anymore
- From same prompt where we're inside WSL distro prompt edit a `wsl.conf` file:
`nano /etc/wsl.conf`
- Contents of the file after modification (full file)
```
	[boot]
	systemd=true
	[network]
	generateResolvConf = false
```
- Save and close file
	CTRL+X
	Y
- We've added `generateResolvConf = false` to tell WSL to NOT generate `resolv.conf` anymore, so now we have to generate it manually
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

### Example for static IP configuration
OK now we have networking and DNS resolving working, so we can  assign IP manually, this is NOT required if your DHCP works fine, but some people prefer static IPs (me included), so I'll show that here as well.

- Open config file again using that WSL prompt
```
cd /lib/systemd/network/
nano wsl_external.network
```
- Simple config contents
```
[Match]
Name=eth0

[Network]
Description=WSL_external
DHCP=false
Address=192.168.0.33/24
Gateway=192.168.0.1
```

- Save and close file
```
CTRL+X
	Y
```
- It's probably obvious but let's explain important stuff
	- `DHCP=false` simply opposite of true, eh? disabling DHCP addressing
	- `Address=` enter IP that you desire, make sure it's free, available, and don't forget that `/24` at the end (netmask)
	- `Gateway=` is IP of your next hop, your gateway, router
- Restart the networking service
`systemctl restart systemd-networkd`
- Check if you've got IP now
`ip a`
- You should see new IP v4 address, note I had .34 now I've setup .33
- Testing this new IP from inside and outside says it's working!
- Note that you may temporarily see both old and new IP via `ip a`, that will disappear after restart

Final test is to see if everything works after restart of everything - WSL and the whole host PC!

- Shutdown WSL instance
```
exit
exit
wsl --shutdown
```
- Reboot your whole PC
- If you have WSL connected to that WiFi adapter, make sure you're reconnected (before or after starting WSL, doesn't matter); yeah, I must've skipped that part at least 3x while writing this tutorial
- Start WSL instance, eg.
`wsl -d Ubuntu`
- If you still have that test Apache check if webpage is available without manually starting any services, it should work from any 3rd device in same network; or you can go back to that part and re-run all commands for test
- Check from inside WSL with:
```
ip a
networkctl status eth0
ping 1.1.1.1
ping google.com
```

### Now that's really all!

Useful links (that I've found a day AFTER posting initial version of this guide):

- Article about bridged networking:
https://randombytes.substack.com/p/bridged-networking-under-wsl
- Article about systemd:
https://randombytes.substack.com/p/migrating-from-systemd-genie-to-native
- bottle-imp (I did not try this yet, but it's related to the systemd topic, fixes some WSL-systemd omissions):
https://github.com/arkane-systems/bottle-imp

And some official docs about systemd networking:

- References to Linux networking configuration (ArchLinux, Ubuntu, networkd, resolved)
	- Arch Linux - networkd
	https://wiki.archlinux.org/title/systemd-networkd
	- Ubuntu - networkd
	https://manpages.ubuntu.com/manpages/jammy/man5/systemd.network.5.html
	- Arch Linux - resolved
	https://wiki.archlinux.org/title/systemd-resolved
	- Ubuntu - resolved
	https://manpages.ubuntu.com/manpages/jammy/man8/systemd-resolved.service.8.html
