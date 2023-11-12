# Storyline: Using the Get-Process and Get-service
#$user = whoami | Split-Path -Leaf
Get-Process #| Select-Object Path, ProcessName, ID

#Read-Host "Press 'Enter' when you are done"
        #incident_menu
 #| 
#Export-Csv -Path "C:\Users\$user\SYS320\myProcesses.csv" -NoTypeInformation
# Get-Process | Get-Member
#Get-Service | where { $_.Status -eq "Running" } |
#Export-Csv -Path "C:\Users\$user\SYS320\myServices.csv" -NoTypeInformation
