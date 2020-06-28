# WSL2-fixes
Fix-up scripts for WSL2, mainly networking related

# wsl2-net.ps1
wsl2-net.ps1 is a workaround, for people with Win10 Pro, which uses Hyper-V Virtual Switch functionality, some Powershell, and some bash with WSL commands, to install WSL2 (Ubuntu 20.04), and setup a proof-of-concept WSL2 instance that has NORMAL IP address exposed to local network, as would a standalone VM have. This allows you to access WSL2 services from devices in your local network, or from public Internet (both require propper firewalling and routing rules to be setup on your local network router/firewall device(s))
