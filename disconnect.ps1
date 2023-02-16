$computerName = Read-Host "Name/IP of the machine"

Get-WmiObject -Class Win32_NetworkAdapter -Filter "NetConnectionID != NULL" -ComputerName $computerName |
ForEach-Object { $_.Disable() }
