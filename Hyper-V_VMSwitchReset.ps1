# -- IMPORTANT ---
# Add this to your .wslconfig: 
# networkingMode=bridged
# vmSwitch=WSL_external

#We need to shutdown the WSL-VMs to change the switch and network configuration
Get-Service LxssManager | Stop-Service
Get-Service WslService | Stop-Service
Start-Sleep -Seconds 9

# get the first NIC that has an working connection
$NICS = Get-NetAdapter -Physical | Where-Object { $_.Status -EQ 'Up' }
Write-Host "Using:" $NICS[0].Name "|" $NICS[0].InterfaceDescription -ForegroundColor Cyan

#Remove binding to switch and the switch
Set-NetAdapterBinding -Name $NICS[0].Name -ComponentID vms_pp -Enabled $False
Remove-VMSwitch "*WSL_external*" -Force

#Create new switch and the binding to the first NIC that is up
New-VMSwitch "WSL_external" -NetAdapterName $NICS[0].Name -MinimumBandwidthMode Weight -AllowManagementOS $true
Get-VMSwitch -Name "*WSL_external*"
Get-NetIPConfiguration -InterfaceAlias "*WSL_external*"

# Restart the WSL and Linux services
Get-Service LxssManager | Start-Service
Get-Service WslService  | Start-Service