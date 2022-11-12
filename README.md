# WSL2-fixes
Fix-up scripts for WSL2, mainly networking related

# networkingMode=bridged.md
networkingMode=bridged.md is detailed tutorial initially written as comment to WSL bug thread, and I'm placing it here for future reference.
Comtains detailed instructions to setting up bridged networking in WSL2, together with systemd setup, systemd networking configuration, and bunch of reference links about all the included tools, commands, workflows, etc

# networkingMode=bridged - quick setup.md
networkingMode=bridged - quick setup.md is shorter version of the above, for those that have already some experience with Hyper-V, Virtual Switch, and setting up WSL2 with bridged networking and systemd, yet need a (way shorter) reference for commands and configs in question.

# networkingMode=bridged-ultra-quick.md
networkingMode=bridged-ultra-quick.md is ultimately compressed guide, just commands and configs, in cases when you're simply reinstalling WSL or similar

# wsl2-net.ps1
wsl2-net.ps1 is a workaround, for people with Win10 Pro, which uses Hyper-V Virtual Switch functionality, some Powershell, and some bash with WSL commands, to install WSL2 (Ubuntu 20.04), and setup a proof-of-concept WSL2 instance that has NORMAL IP address exposed to local network, as would a standalone VM have. This allows you to access WSL2 services from devices in your local network, or from public Internet (both require propper firewalling and routing rules to be setup on your local network router/firewall device(s))
