Originally posted here:
https://github.com/microsoft/WSL/issues/4150#issuecomment-1288152162

# ABOUT THIS TUTORIAL
OK folks, after many years watching WSL space, then another year watching WSL2 on W11 from the bench (older W10 PC) I finally got up to date.
Since I see many questions I've decided to write an expanded tutorial for this thread.
Please note that this is detailed guide, and it is long and going through it may be bit slower. There are now also a "quick" and "ultra-quick" versions available here : https://github.com/luxzg/WSL2-fixes
But it is very recommended to at least read through this full guide once to get the full understanding of the process and available options and settings.
I will do my best to keep all of these guides up to date according to new findings in the original GitHub issue thread (4150).

# REQUIREMENTS

-  Windows 11 Pro license
 	- please, this is available everywhere and cheap, and offers so much more than just easier WSL networking, if you're a PRO then buy a PRO !
-  64-bit PC with 64-bit UEFI BIOS
 	- Windows 11 will NOT run on 32-bit hardware, and also some mini PCs and tablets that have 64-bit Atom CPUs sometimes have 32-bit UEFI so those won't work either, I've tried
-  Internet connection
 	- to download tools, Windows installation, WSL installation, WSL distro, and everything else
-  Optional: USB stick
 	- only if you need to upgrade from Windows 10 on unsupported hardware
-  ... time

# For poor folks that are on the bench (Windows 10)

-  Install Windows 11 Pro
 	- if not allowed by Microsoft then use Rufus to create bootable USB stick that allows installation on any x64 PC without the need to have TPM, certain CPU model, and so on
- If you've been stuck on W10 (like me) for a year waiting for something to happen - stop waiting!
- Not to promote any external tools, but MS did it to themselves:
 	- https://pureinfotech.com/rufus-create-bootable-windows-11-22h2-usb/
- This link will tell you where to get Rufus, how to use it to download Windows 11 ISO, how to create bootable USB stick, and how to remove the 4GB, Secure Boot, TPM and CPU model limitations (see their section about unsupported hardware)
- Then you can use this USB to either boot fresh install, or run the installer from that USB from inside Windows 10 for an in-place upgrade
- There's some more work for when language of W10 and W11 installation differ, if you stumble upon that msg me, those instructions are beyond the scope of this overal tutorial

# WSL 2 with proper networking
This section is large, so just be patient and follow steps

### After you're in Windows 11 Pro - update Windows 11 fully

- Use Windows Update AND Microsoft Store, update everything, OS and apps
- This functionality is no longer limited to Insider builds, I am running Windows 11 Pro 22H2 (stable) and this tutorial was made on that version

### OPTIONAL: Install and use Microsoft Terminal
I did this tutorial using Terminal, but in reality all commands can be run via usual cmd or PowerShell so if you want you may skip this, just make sure to use PowerShell prompt instead for parts that use PowerShell commandlets

- Official link to Terminal on Microsoft Store, just click and install:
https://aka.ms/terminal

# Install Hyper-V features and tools
Open cmd or PowerShell or Terminal as Administrator (eg right click on Start button and pick "Terminal (Admin)") and run the rest of commands in elevated prompts - ALWAYS!

### Check system info
`systeminfo`

- Check if your virtualization is enabled in BIOS / UEFI firmware under "Hyper-V Requirements"
- Also check that you have "Windows 11 Pro" under "OS Name"

# Have the Virtual Machine Platform optional component enabled

- You can do this by running the following command in an elevated prompt:
`DISM /Online /Enable-Feature /All /FeatureName:Microsoft-Hyper-V /all`
- You will see something like:
```
	The operation completed successfully.
	Restart Windows to complete this operation.
	Do you want to restart the computer now? (Y/N)
```
- Restart your PC
```
Y
```

# OPTIONAL : updating WinGet and PowerShell to latest stable versions
This is really optional, as Windows 11 is shipped with PowerShell and winget by default and both are relatively recent if you've used Windows Update to the fullest (W11 22H2)

- From elevated Terminal (Admin) prompt:
	- update all packages using winget
	- !! WARNING !! : this will update other applications as well (!!) so you may want skip this command if you want to keep any of your existing apps on current versions
```
winget upgrade --all
```
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
To get latest updates and features, including virtual switch bridging you NEED the latest Preview version and HAVE TO get it from Microsoft Store

- Official link to WSL on Store
	- https://aka.ms/wslstorepage
	- Store app link: ms-windows-store://pdp/?productid=9P9TQF7MRM4R
	- Just click GET to install, and wait for it to finish

# Install WSL distro, this is for Ubuntu

- Install WSL2 distro according to your preferences, eg. Ubuntu from Microsoft Store:
	- https://www.microsoft.com/store/productId/9PDXGNCFSCZV
	- Store app link: ms-windows-store://pdp/?productid=9PDXGNCFSCZV
	- Again just click GET, and then be patient, it's ~670 MB download
- Alternative - Ubuntu 22.04.1 LTS link:
	- https://www.microsoft.com/store/productId/9PN20MSR04DW
	- Store app link: ms-windows-store://pdp/?productid=9PN20MSR04DW
- There are many other alternatives, like the ones below:
	- Debian, SLES (SUSE), Kali Linux, Oracle Linux, Alpine Linux, AlmaLinux, Pengwin, Fedora, Rocky, AOSC, Swabbie (CBL-Mariner), Arch Linux, Parrot Security, OpenSuse, etc.
	- Some are available through Microsoft Store, some are also available using command : `wsl --list --online`
	- This guide is based on Ubuntu distro

# Post-install steps

- In elevated PowerShell / Terminal prompt (run as Administrator)
- Update WSL installation (just in case):
`wsl --update`
- And get current versions:
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
- NOTE! If `--version` does not work you probably DO NOT have Preview version from Microsoft Store installed !! Go back and fix that before you continue!
- Close WSL for now:
`wsl --shutdown`

# Creating Virtual Switch in Hyper-V Manager

- Run Hyper-V Manager
	- On the left select your PC
	- On the right select Virtual Switch Manager
	- Inside manager select "New virtual network switch"
	- On the right select "External"
	- Then click "Create Virtual Switch"
	- Under "Name:" enter distinctive name, eg "WSL_external"
	- Make sure to select exact physical adapter (WiFi, LAN, etc.) and since this is most likely your only adapter, have checkbox checked under "Allow management operating system to share this network adapter"
	- Apply, Yes, OK

This can also be done in PowerShell but I figure GUI is more user friendly, see links at the bottom for reference article with pictures.

# Create WSL configuration file with correct settings

- In elevated PowerShell prompt, continued
```
cd ~
New-Item .wslconfig
.\.wslconfig
```
- Select your choice of text editor to open file
- If you forgot what was your virtual switch named run this in PowerShell:
```
Get-VMSwitch -SwitchType External | Select Name, SwitchType, NetAdapterInterfaceDescription, AllowManagementOS
```
- Example output from my PC:
```
Get-VMSwitch -SwitchType External | Select Name, SwitchType, NetAdapterInterfaceDescription, AllowManagementOS

Name         SwitchType NetAdapterInterfaceDescription                                     AllowManagementOS
----         ---------- ------------------------------                                     -----------------
WSL_external   External Killer(R) Wi-Fi 6 AX1650x 160MHz Wireless Network Adapter (200NGW)              True
```

### Inside text editor

- Now add to your `.wslconfig` file text like this:
```
[wsl2]
networkingMode=bridged
vmSwitch=WSL_external
```
- To clarify: `vmSwitch=` line defines connection to External Virtual Switch from Hyper-V and needs to be set exactly same as the name of virtual (External) switch that we've set up in Virtusl Switch Manager (see `Get-VMSwitch` output above)
- Also more options were added in later versions, but we DO NOT use them for now:
```
 	macAddress
 	dhcp
 	dhcpTimeout
 	ipv6
```
- You can also define other optional settings here according to your needs and preferences (like CPU counts, memory size, etc.), see links at the end for official documentation
- Save and close the file

### VERY IMPORTANT !!! I have seen several posts that made typos in config, if the tutorial "doesn't work" please make sure you check your `.wslconfig` and use COPY PASTE !!!

# WSL distro first run

- Now you can run your distribution for the first time
- Change the name according to what you've installed from Microsoft Store earlier, in this case:
	- Start menu -> Ubuntu
- It will open first time GUI setup so run with it
- Pick language, Next, enter your name, username and password (2x)
	- Note: I had issues because apparently you can't use non latin characters in your name
- Keep pressing Continue / Next / Setup, and so on, ... and Finish

# Starting and updating your WSL2 distro

- In Terminal / PowerShell
- Listing all distros:
`wsl --list -v`
- Updating WSL if you haven't already:
`wsl --update`
- Starting distros (eg. start Ubuntu):
`wsl -d Ubuntu`

# Checking networking

- Now check your IP and IP of your WSL distro in Terminal, use a separate window/tab for each
- Checking your Windows 11 networking configuration:
`ipconfig`
- Example from my PC:
```
LAN
IPv4 Address. . . . . . . . . . . : 192.168.0.26
WiFi vEthernet
IPv4 Address. . . . . . . . . . . : 192.168.0.27
Default switch (that annoying one that changes IP)
IPv4 Address. . . . . . . . . . . : 172.24.64.1
```
- You can also get it by querying vEthernet interface if you've used the option to "Allow management operating system to share this network adapter"
`netsh interface ip show addresses "vEthernet (WSL_external)"`
- Sample output of my PC:
```
Configuration for interface "vEthernet (WSL_external)"
    DHCP enabled:                         Yes
    IP Address:                           192.168.0.27
    Subnet Prefix:                        192.168.0.0/24 (mask 255.255.255.0)
    Default Gateway:                      192.168.0.1
    Gateway Metric:                       0
    InterfaceMetric:                      35
```
- To chech WSL distro IP, run the following inside distro, if Ubuntu then this is the command:
`ip a`
- Should be only one IP in the output, eg.:
`inet 192.168.0.33/24 brd 192.168.0.255 scope global eth0`
- NOTE: some distros use `ifconfig` or other commands

So my WiFi, LAN, AND distro IPs are all different, and assigned by REAL router's DHCP service on my network !!
And most important - my distro does NOT have that weird 172.24..... IP of "Default switch".

- You can check pinging outside IP or domain name to verify connectivity and DNS resolving:
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

- You will want to update your distro next
- First we need to get `root` rights using `sudo` (this is the equivalent of "Run as Admin" in Windows)
```
sudo su
	<password>
```
- Then run these `apt` commands to update and upgrade everything in WSL OS:
```
apt update
apt upgrade
	y
apt full-upgrade
	y
```
- NOTE: in case update/upgrade fails, you may need to re-connect your WiFi or connect that physical cable to the network adapter of your choice, then try again
	- I kept having that exact issue as I have multiple adapters on my PC, and I keep forgetting my WiFi doesn't auto-connect
- Checking Ubuntu version after upgrades
```
lsb_release -a
```
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

- We can also test some simple GUI apps for WSL by installing these:
```
apt install x11-apps
```
- Test them by running these commands:
```
xeyes &
xcalc &
```
- If they run fine, close them on "X", just as any other Windows GUI app

# VERY OPTIONAL! DO NOT RUN if you want to keep your distro clean

- The following is nothing dangerous, we're just installing web server and opening port 80 to it, and if you want we'll also remove it at the end
- To confirm networking works for incoming traffic we will install a web server (Apache) and try to access it from an outside device eg. from mobile phone on the same WiFi, or another PC in the same LAN
- Command to install server, make sure you're still running as sudo (root), if not - you'll need to repeat `sudo su` as before, then run the install command:
```
apt install apache2
	y
```
- Restart and check status of `apache2` service like this:
```
service apache2 restart
service apache2 status
```
- Allow listening on port 80 through `iptables`
	- If you use other port change accordingly
`iptables -I INPUT -p tcp -m tcp --dport 80 -j ACCEPT`
- Check if `apache2` is listening on the ports as you'd expect with command:
```
lsof -i -P -n | grep LISTEN
```
- And try it out! Using browser from 3rd device in your network open URL with your IP, eg.:
	- http://192.168.0.33
- Make sure you enter IP that's shown in your WSL distro's `ip a` command output!
- It should show a web page saying something like `Apache2 Default Page ... It works!` etc.
- Also note that using either IP or localhost should work from Windows host PC.
- Apache will NOT run automatically on distro reboot (shutdown and re-run) so if you want to continue using Apache you'll need to run the service again manually eg.
```
sudo service apache2 start
```
- If you have setup `systemd` (see optional steps below, after references and links) you can now also setup Apache to always run by enabling the service autostart, this is also good test if `systemd` is actually working, command is:
```
sudo systemctl enable apache2
```
- But everything else is outside of this tutorial, and if you don't need/want Apache you can remove it now as well
- If you don't need/want to keep Apache you can remove it now as well by running:
```
apt remove apache2
	y
```
- To remove `iptables` entry run simmilar command as before except replacing `-I` (insert) to `-D` (delete)
```
iptables -D INPUT -p tcp -m tcp --dport 80 -j ACCEPT
```

# Conclusion
### THAT'S IT FOLKS!

- You have Ubuntu in WSL2, proper networking, in and out of VM
- You have DHCP from your router (or corporate network)
- You have local WSLg GUI apps if needed working fine, as intended
- You have `localhost` access from your host Windows PC if you still need it

# NOTES

- If you use VPN - you can now start VPN session directly from your WSL distro
- If you often switch between multiple network adapters, eg. WiFi and LAN on your laptop, you could create `New-NetSwitchTeam`, but I've since found that it's way easier to just open `Virtual Switch Manager` from `Hyper-V Manager`, and edit the bridge network by selecting currently active physical network adapter from the dropdown menu under `External network` and `Apply` the change, it takes a few seconds only, and works without restarting WSL instance
- If you are still stuck on Windows 10 or 11 on Home version please go get a Windows 11 Pro key for <10$

# References and links:
### (I have collected links to almost every command in this tutorial, not counting the testing section, if you want to learn more - start reading!)

- GitHub issue asking for Hyper-V External adapters on WSL 2:
	- https://github.com/microsoft/WSL/issues/5835
- GitHub comment that discovered the hidden feature:
	- https://github.com/microsoft/WSL/issues/4150#issuecomment-1018524753
	- ghost commented on Jan 21 -> **(MANY THANKS TO GHOST!)**
- GitHub comment that reported about other new networking features:
	- https://github.com/microsoft/WSL/issues/4150#issuecomment-1031407472
	- These options have been added at WSL v.0.51
- Official link to WSL config settings:
	- https://learn.microsoft.com/en-us/windows/wsl/wsl-config
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

### The following (optional) sections are describing how to enable and configure `systemd` and related networking services.

# OPTIONAL: systemd setup and check
`systemd` is the default init system in many distributions right now, so we'd want to use that too to be as close "to the real thing" as possible.

- This is NOT needed for working networking, but I do recommend it as eg. Ubuntu usually uses `systemd` by default, and its deamons `networkd` and `resolved` handle the networking
- From inside WSL prompt we need to configure `wsl.conf` file for `systemd` usage, so edit the file like this:
`sudo nano /etc/wsl.conf`
- Copy paste the following into the file:
```
[boot]
systemd=true
```
- Exit `nano` editor and save the file:
```
CTRL+X to close, and Y to confirm save over same filename
```
- Shut down WSL instance by running these commands inside active WSL distro's prompt:
```
exit
wsl --shutdown
```

- Start your WSL instance again, eg.:
`wsl -d Ubuntu`
- We can now check if `systemd` is working by running this in the WSL prompt:
`systemctl list-unit-files --type=service`

- Note: there have been reports that enabling `systemd` on existing WSL2 instance can make it stop responding altogether, but simple fix is to reboot the whole host PC, doing just WSL restart wasn't enough, but after reboot everything worked as expected

With `systemd` enabled you should have networking working as earlier.
But if you want to step away from WSL's helping hand completely, have full DHCP / IPv4 / IPv6 control from inside Linux distro, and so on - then we need a few more tweaks. Check next section!

# Completely client-side networking with systemd related services

- Start Terminal or PowerShell in elevated prompt as before
- Stop WSL:
```
wsl --shutdown
```
- Edit `.wslconfig` file:
```
cd ~
.\.wslconfig
```
- Full contents (added `dhcp=false` and `ipv6=true`)
```
[wsl2]
networkingMode=bridged
vmSwitch=WSL_external
dhcp=false
ipv6=true
```
- `dhcp=false` will disable WSL "helper" (its own DHCP service helper) that usually assigns IP address, and will let the OS inside WSL instance do all the work
- `ipv6=true` will explicitly force IPv6 which helps with `localhost` communication for apps that don't setup listening ports specifically for `0.0.0.0:<port>`
- Save the `.wslconfig` file and exit text editor

### Now we need to configure networking inside WSL distro OS, because we've lost the help from WSL (sub)system itself, so let's dig in!

- Still in that elevated prompt, start WSL again, eg.:
`wsl -d Ubuntu`
- Get root:
`sudo su`
- Confirm that you don't have any networking:
`ip a`
- You will see something like this, `eth0` with MAC but no IP address assigned:
```
6: eth0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
	link/ether 5c:bb:f6:9e:ee:fa brd ff:ff:ff:ff:ff:ff
```
- To fix this go to directory in which Ubuntu keeps networking configs (if you use different OS you'll need to dig deeper, see reference links at the end of this section):
`cd /lib/systemd/network/`
- Create and edit a new file:
`nano wsl_external.network`
- Contents of the file (use copy/paste to avoid mistakes):
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
- Explanation:
	- `eth0` is name of the interface
	- `Description` is whatever you want it to be (doesn't have to match any existing names)
	- `DHCP=true` tells the networking stack to use DHCP, allowing automatic IP assignment via local router
	- `IPv6AcceptRA=true` is to allow IPv6
	- (For the rest see official docs, linked at the end of this section)
- In short - this config is for obtaining IP address automatically via DHCP service, including working IPv6

- Save and close the file
```
CTRL+X
	Y
```
- Restart the networking service:
```
systemctl restart systemd-networkd
```
- And make sure it's enabled for future auto-start on WSL start:
```
systemctl enable systemd-networkd
```
- Check if you've got IP now: 
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
- From the same prompt where we're inside WSL distro prompt edit a `wsl.conf` file:
```
nano /etc/wsl.conf
```
- Contents of the file after modification should be (full file contents):
```
[boot]
systemd=true
[network]
generateResolvConf = false
```
- Save and close file
```
CTRL+X
	Y
```
- We've added `generateResolvConf = false` to tell WSL to **NOT** generate `resolv.conf` anymore, so now we have to generate it manually
- Edit `resolv.conf` with `nano` editor:
```
nano /etc/resolv.conf
```
- Contents of this file:
```
nameserver 8.8.8.8
```
- Save and close file
```
CTRL+X
	Y
```
- Restart service by running:
```
systemctl restart systemd-resolved.service
```
- And make sure it is enabled for future auto-start:
```
systemctl enable systemd-resolved.service
```
- Test resolving by simply pinging some FQDN, eg.:
`ping google.com`

### Example for static IP configuration
OK now we have networking and DNS resolving working, so we can also assign IP manually, this is NOT required if your DHCP works fine, but some people prefer static IPs (me included), so I'll show that here as well.

- Edit network config file again using that WSL prompt:
```
nano /lib/systemd/network/wsl_external.network
```
- Simple config example for static IPv4 addressing:
```
[Match]
Name=eth0

[Network]
Description=WSL_external
DHCP=false
Address=192.168.0.93/24
Gateway=192.168.0.1
```
- Save and close file
```
CTRL+X
	Y
```
- It's probably obvious but let's explain the important stuff:
	- `DHCP=false` is simply opposite of previous true, disabling the DHCP addressing
	- `Address=` enter IP that you desire, make sure it's valid, free, available, and don't forget that `/24` at the end (your subnet netmask)
	- `Gateway=` is IP of your next hop, your gateway, router
- Restart the networking service:
```
systemctl restart systemd-networkd
```
- Check if you've got IP now:
`ip a`
- You should see new IPv4 address, note that earlier I had `.34`, and now I've setup `.93`
- Testing this new IP from inside and outside says it's working!
- Note that you may temporarily see both old and new IP via `ip a`, that will disappear after WSL restarts

Final test is to see if everything works after restart of everything - WSL and the whole Windows host PC!

- Shutdown WSL instance:
```
exit
exit
wsl --shutdown
```
- Reboot your whole PC
- If you have WSL connected to that WiFi adapter, make sure you're reconnected (before or after starting WSL, doesn't matter); yeah, I must've skipped that part at least 3x while writing this tutorial
- Start WSL instance again, eg.:
```
wsl -d Ubuntu
```
- If you still have that test Apache server check if webpage is available without manually starting any services, it should work from any 3rd device in same network; or you can go back to that part and re-run all commands for test (see earlier part of this guide)
- Check IPs and networking from inside WSL with:
```
ip a
networkctl status eth0
ping 1.1.1.1
ping google.com
```

### Now that's really all!

Useful links:

- Article about bridged networking:
https://randombytes.substack.com/p/bridged-networking-under-wsl
- Article about systemd:
https://randombytes.substack.com/p/migrating-from-systemd-genie-to-native
- bottle-imp (I did not try this yet, but it's related to the systemd topic, and fixes some WSL-systemd omissions):
https://github.com/arkane-systems/bottle-imp

And some official docs about `systemd` networking:

- References to Linux networking configuration (ArchLinux, Ubuntu, networkd, resolved)
	- Arch Linux - networkd
	https://wiki.archlinux.org/title/systemd-networkd
	- Ubuntu - networkd
	https://manpages.ubuntu.com/manpages/jammy/man5/systemd.network.5.html
	- Arch Linux - resolved
	https://wiki.archlinux.org/title/systemd-resolved
	- Ubuntu - resolved
	https://manpages.ubuntu.com/manpages/jammy/man8/systemd-resolved.service.8.html



### Next section simply lists all config files that were changed, the way I currently use them on my own PC and WSL

**vSwitch**
```
Get-VMSwitch | Select Name, SwitchType, NetAdapterInterfaceDescription, AllowManagementOS

Name           SwitchType NetAdapterInterfaceDescription                                     AllowManagementOS
----           ---------- ------------------------------                                     -----------------
WSL_external     External Killer(R) Wi-Fi 6 AX1650x 160MHz Wireless Network Adapter (200NGW)              True
Default Switch   Internal                                                                                 True
```

**.wslconfig**
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
(Note: last 3 options are actually the default behaviour, omitting them makes no difference)

**/etc/wsl.conf**
```
[boot]
systemd=true
[network]
generateResolvConf = false
```

**/usr/lib/systemd/network/wsl_external.network**
```
[Match]
Name=eth0

[Network]
Description=WSL_external
DHCP=false
Address=192.168.0.93/24
Gateway=192.168.0.1
```

**/etc/resolv.conf**
```
nameserver 8.8.8.8
```

### Using these configurations here are my IP outputs from WSL:

**ip a**
```
6: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether 5c:bb:f6:9e:ee:55 brd ff:ff:ff:ff:ff:ff
    inet 192.168.0.93/24 brd 192.168.0.255 scope global eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::5ebb:f6ff:fe9e:ee55/64 scope link
       valid_lft forever preferred_lft forever
```
**networkctl status eth0**
```
● 6: eth0
                     Link File: /usr/lib/systemd/network/99-default.link
                  Network File: /usr/lib/systemd/network/wsl_external.network
                          Type: ether
                         State: routable (configured)
                  Online state: online
                          Path: acpi-VMBUS:00
                        Driver: hv_netvsc
                    HW Address: 5c:bb:f6:9e:ee:55
                           MTU: 1500 (min: 68, max: 65521)
                         QDisc: mq
  IPv6 Address Generation Mode: eui64
          Queue Length (Tx/Rx): 64/64
              Auto negotiation: no
                         Speed: 144Mbps
                        Duplex: full
                       Address: 192.168.0.93
                                fe80::5ebb:f6ff:fe9e:ee55
                       Gateway: 192.168.0.1
             Activation Policy: up
           Required For Online: yes
             DHCP6 Client DUID: DUID-EN/Vendor:0000ab110d03057677c6e49d0000

Nov 12 23:43:43 DESKTOP-2BF6F64 systemd-networkd[88]: eth0: Link UP
Nov 12 23:43:43 DESKTOP-2BF6F64 systemd-networkd[88]: eth0: Gained carrier
Nov 12 23:43:45 DESKTOP-2BF6F64 systemd-networkd[88]: eth0: Gained IPv6LL
```

### And this is my IP on Windows host, sharing same physical adapter:

**netsh interface ip show addresses "vEthernet (WSL_external)"**
```
Configuration for interface "vEthernet (WSL_external)"
    DHCP enabled:                         Yes
    IP Address:                           192.168.0.27
    Subnet Prefix:                        192.168.0.0/24 (mask 255.255.255.0)
    Default Gateway:                      192.168.0.1
    Gateway Metric:                       0
    InterfaceMetric:                      35
```

### THE END
