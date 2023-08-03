# WSL2-fixes
Fix-up guides and scripts for WSL2, mainly networking related:

* `networkingMode=bridged.md` is detailed tutorial initially written as comment to WSL bug thread, and I'm placing it here for future reference.
Contains **full** guide with detailed instructions to setting up bridged networking in WSL2, together with systemd setup, systemd networking configuration, and bunch of reference links about all the included tools, commands, workflows, etc.
  * Updated: 2022-11-13
  * Link: https://github.com/luxzg/WSL2-fixes/blob/master/networkingMode%3Dbridged.md

* `networkingMode=bridged - quick setup.md` is shorter version of the above, for those that have already some experience with Hyper-V, Virtual Switch, and setting up WSL2 with bridged networking and systemd, yet need a (way shorter) **quick** reference for commands and configs in question.
  * Updated: 2022-11-13
  * Link: https://github.com/luxzg/WSL2-fixes/blob/master/networkingMode%3Dbridged%20-%20quick%20setup.md

* `networkingMode=bridged-ultra-quick.md` is ultimate compressed guide, just a list of commands and related configs, in cases when you're simply reinstalling WSL or similar and want **ultra-quick** checklist to follow.
  * Updated: 2022-11-13
  * Link: https://github.com/luxzg/WSL2-fixes/blob/master/networkingMode%3Dbridged-ultra-quick.md

* `Removing_network_bridge_and_systemd_settings.md` is a short list of commands to revert to original settings, in cases when you want to go back to original NAT networking for some reason.
  * Updated: 2022-11-26
  * Link: https://github.com/luxzg/WSL2-fixes/blob/master/Removing_network_bridge_and_systemd_settings.md

* `wsl2-net.ps1` was a workaround, for people with Win10 Pro, which uses Hyper-V Virtual Switch functionality, some Powershell, and some bash with WSL commands, to install WSL2 (Ubuntu 20.04), and setup a proof-of-concept WSL2 instance that has NORMAL IP address exposed to local network, as would a standalone VM have. This would allow you to access WSL2 services from devices in your local network, or from public Internet (both require proper firewall and routing rules to be setup on your local network router/firewall device(s))
  * (obsolete)

* `Hyper-V_VMSwitchReset.ps` to change the network adapter that is bound to the Hyper-V Virtual Switch i.e. changing from wired to wireless networking you net to recreate the switch and bind the "other" network adapter to it. This is only possible if the WSL instances are not running. You can use this to rebind the network adpater automatically that is found and connected to a network.

* `scratchbook.md` is just to remember stuff I need sometimes on WSL
  * Updated: 2022-11-13
  * Link: https://github.com/luxzg/WSL2-fixes/blob/master/scratchbook.md
