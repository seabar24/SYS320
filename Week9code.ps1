# Storyline: Gets the Processes and Services Running on your system. Gets the DHCP Server's IP Address and DNS server IPs. A program to start and stop Windows Calculator

# Used to set the user for the file path
$user = whoami | Split-Path -Leaf
# Gets the Running Processes and Services on the System. Exports them to a CSV file
 Get-Process | Select-Object Path, ProcessName, ID, StartTime | Export-Csv -Path "C:\Users\$user\Desktop\myProcesses.csv" -NoTypeInformation
 Get-Service | where { $_.Status -eq "Running" } | Export-Csv -Path "C:\Users\$user\Desktop\myServices.csv" -NoTypeInformation

# Get's IP Address, Default Gateway, and DNS Domain
# Get-WMIobject -Class Win32_NetworkAdapterConfiguration | Where { $_.IPAddress } | Select-Object -ExpandProperty IPAddress
# Get-WMIobject -Class Win32_NetworkAdapterConfiguration | Where { $_.DefaultIPGateway } | Select-Object -ExpandProperty DefaultIPGateway
# Get-WMIobject -Class Win32_NetworkAdapterConfiguration | Where { $_.DNSServer } | Select-Object -ExpandProperty DNSDomain

# Get's DHCP Server and DNS Server IPs
$DHCP=Get-WMIobject -Class Win32_NetworkAdapterConfiguration | Where { $_.DHCPServer } | Select-Object -ExpandProperty DHCPServer
Write-Host "`nDHCP Server: $DHCP"
$DNS=Get-WMIobject -Class Win32_NetworkAdapterConfiguration | Where { $_.DNSServerSearchOrder } | Select-Object -ExpandProperty DNSServerSearchOrder
Write-Host "DNS Server IPs: $DNS"
Start-Sleep -Seconds 2

# Starts and Stops Windows Calculator
Start-Process "calc.exe"
Start-Sleep -Seconds 10
Stop-Process -Name "win32calc" -Force -ErrorAction SilentlyContinue

