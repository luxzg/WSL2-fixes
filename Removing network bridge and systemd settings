### Removing network bridge settings

One person wanted to revert changes and go back to NAT. So just in case that there are more people with this wish, here is a short list of commands to revert to original settings. Some understanding of the process is assumed because to set this up in the first place you've had to read the full guide, and these commands are simply reverse of the commands in the guide.

On to commands (and comments in # lines):
```
# inside WSL distro
sudo nano /etc/wsl.conf
# erase modifications, eg.
	[network]
	generateResolvConf = false
# save and exit editor
	Ctrl + X ; Y
# erase networking config if you've used one like this:
rm /lib/systemd/network/wsl_external.network
# disable networking services if you've used systemd networking services
sudo systemctl disable systemd-networkd
sudo systemctl disable systemd-resolved
# exit WSL
exit
# shutdown all instances using Windows cmd.exe / Terminal / PowerShell window
wsl.exe --shutdown
# edit .wslconfig from eg. PowerShell prompt
cd ~
.\.wslconfig
# remove all lines like following (irrespective what is behind = ... )
	networkingMode= ...
	vmSwitch= ...
	dhcp= ...
	macAddress= ...
	ipv6= ...
# save file and exit editor
# then start your distro again
wsl.exe -d <distro name>
```

This should revert all changes to state before going through my guides, any of them, and revert you to default NAT based networking.

If you also want to disable `systemd` (optional part of the guide) then also do this:
```
# inside WSL distro
sudo nano /etc/wsl.conf
# erase modifications, eg.
	[boot]
	systemd=true
# save and exit editor
	Ctrl + X ; Y
```

Then exit and restart your distro.

Please note that any changes to `.wslconfig` or `wsl.conf` require full restart of WSL distro. Default timeout is 60 seconds, so either exit all WSL instances and wait for 60 seconds, or using `wsl --shutdown`. To check if there are any WSL distros still runing in the background you can run this in the cmd.exe / Terminal / PowerShell prompts:
```
wsl --list --running
```
It needs to reply:
```
There are no running distributions.
```
Only after that is assured, can you be certain that changes to configuration files will be applied on next WSL/distro start.
