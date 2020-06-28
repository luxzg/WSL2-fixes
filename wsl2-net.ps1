# Required
#    - Windows 10, May 2020 update (version 2004); Pro (Professional) required for Hyper-V Virtual Switch Features
#    - login to Windows as user with local administrator rights, and run this script by using Windows PowerShell -> Run as Administrator
#    - Internet connection

# For more complete tutorial, see what someone wrote here, testing WSL2 inside a Hyper-V VM; you can test this script that way if you want
#  includes whole setup, VM installation, etc:
#    https://boxofcables.dev/trying-wsl2-on-hyper-v/

# Official docs how to install WSL2 on Win10
#    https://docs.microsoft.com/en-us/windows/wsl/install-win10
# or manually install on Windows Server
#    https://docs.microsoft.com/en-us/windows/wsl/install-on-server
# Ubuntu docs about the same thing
#    https://ubuntu.com/wsl

# make a directory for all of this
New-Item -ItemType "directory" -Path "C:\WSL2-Ubuntu-20.04"
cd C:\WSL2-Ubuntu-20.04

#### CLEANUP PART ####
# you can skip / remove this in case you don't want script to touch your existing VM networks

# disconnect your own VMs from WSL switch
Get-VMNetworkAdapter -VMName * | Disconnect-VMNetworkAdapter

# remove old WSL instance
wslconfig /u Ubuntu-20.04

# uninstall Ubuntu appx / Windows Store entry
Get-AppxPackage *ubuntu* | Remove-AppxPackage

# turn off the WSL Windows Feature
dism.exe /online /disable-feature /featurename:Microsoft-Windows-Subsystem-Linux /norestart

#### INSTALL PART ####
# turn on the required Windows Features
Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -NoRestart
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
# you can restart later

# Check for newer WSL kernel
#    https://docs.microsoft.com/en-gb/windows/wsl/wsl2-kernel
#    https://aka.ms/wsl2kernel
# download kernel (MSI installation package)
Invoke-WebRequest -Uri https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi -OutFile wsl_update_x64.msi -UseBasicParsing
# install the MSI quietly
msiexec /i wsl_update_x64.msi /qn

# set WSL2 with new kernel as default
wsl --set-default-version 2
# set default user to root; WARNING! NOT SAFE!
ubuntu2004 config --default-user root

# manuall / scripted install of WSL 2
#    https://docs.microsoft.com/en-us/windows/wsl/install-manual
# download Ubuntu 20.04
Invoke-WebRequest -Uri https://aka.ms/wslubuntu2004 -OutFile Ubuntu2004.appx -UseBasicParsing
# install the appx
Add-AppxPackage .\Ubuntu2004.appx
# rename and unzip the archive
Rename-Item .\Ubuntu2004.appx .\Ubuntu2004.zip
Expand-Archive .\Ubuntu2004.zip .\Ubuntu2004
# run exe to install, this takes some time; may hang, can be interrupted after 1 minute
.\Ubuntu2004\ubuntu2004.exe

#### NETWORKING PART 1 ####
# for clarity - "Killer e2200 GbE NIC" is the name of my own physical NIC (network card, adapter)
#    yours is probably named something else, so change all occurances accordingly
#    if you have multiple NICs pick one that you want WSL to use
#    WARNING! can be destructiove, if you have multiple NICs AND/OR other VMs please read the script before executing!

# shutdown WSL if it's running already
wsl --shutdown
# remove existing WSL Virtual Switch, it will throw error, it is expected, but it will reset WSL switch to default state
Remove-VMSwitch WSL
# set your physical net adapter by disabling VM/Hyper-V related functionality and bringing up TCP/IP
#    not really needed if you did not use WSL or Hyper-V before
#    if you have other VMs connected this will mess it up probably
Disable-NetAdapterBinding -name "Killer e2200 GbE NIC" -ComponentID vms_pp
Enable-NetAdapterBinding -name "Killer e2200 GbE NIC" -ComponentID ms_tcpip
# connect WSL virtual switch to your physical network adapter (NIC)
Set-VMSwitch WSL -NetAdapterName "Killer e2200 GbE NIC"
# enable normal TCP/IP on this adapter
Enable-NetAdapterBinding -name "vEthernet (WSL)" -ComponentID ms_tcpip
# if you have any other VMs, we will connect them to WSL switch;
#    if you have multiple NICs, and/or use other NIC for your other VMs, comment the line below not to mess up your networking
Get-VMNetworkAdapter -VMName * | Connect-VMNetworkAdapter -SwitchName WSL

#### NETWORKING PART 2 ####
# we will create script that reconfigures Ubuntu networking to DHCP+static DNS instead of that dynamic Microsoft stuff
# make an empty script file
New-Item -ItemType "file" -Path "C:\WSL2-Ubuntu-20.04\net-script.sh"
# write script; requires double quotes for new lines
Set-Content C:\WSL2-Ubuntu-20.04\net-script.sh "#my networking script
# remove all IPs from current WSL interface
ip addr flush dev eth0
# enable DHCP for that interface
dhclient eth0
# make wsl.conf and tell it NOT to re-generate your DNS resolve configuration from now on
echo $'[network]\ngenerateResolvConf = false' > /etc/wsl.conf
# setup your static DNS server, I use Google's 8.8.8.8 here
echo $'nameserver 8.8.8.8' > /etc/resolv.conf
# apply network settings
netplan apply
# check new IP
ip addr
# install Apache, you could install anything else, this is just like proof of concept
apt-get install apache2 -y
# if install worked, WSL can access Internet
# now enable default Apache site
a2ensite 000-default
# restart server
service apache2 restart
# check if you can access web page at http://xxx.xxx.xxx.xxx (your WSL's IP)
"
# convert Windows line enddings with Unix style
[string]::Join( "`n", (gc "C:\WSL2-Ubuntu-20.04\net-script.sh")) | sc "C:\WSL2-Ubuntu-20.04\net-script2.sh"

# copy script from Windows directory to Ubuntu temp folder
wsl cp /mnt/c/WSL2-Ubuntu-20.04/net-script2.sh  /var/tmp/net-script2.sh
# run it inside Ubuntu!
wsl bash /var/tmp/net-script2.sh
# if script executed completely go try open that website from some device in your local network (that has access rights to it)
# if you can open - you are done! now your WSL2 has normal network

# Closing thoughts:
# this is a one-time install script, but you will need a shorter version of this script to be run EVERY time you change networks or reboot PC or WSL2
# this shorter script doesn't need the # CLEANUP PART # or # INSTALL PART #, just the two networking parts
# good thing is this is standalone script, all in one file, so you don't need to do anything inside WSL separately after reboots/restarts
# to make it easier, either put this script in your startup scripts/tasks, or add a shotcut to your desktop and run it manually
# you will need to have this script running whenever you want normal networking on WSL2, until Microsoft listens to users and actually fixes it
# for more info see WSL2 issue https://github.com/microsoft/WSL/issues/4210 (and all related issues, there are dozens)

# Change history:
# - 2020-06-28 : Lux, initial version, not yet throughly tested, but working on my PC
