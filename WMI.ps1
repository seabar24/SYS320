﻿# Use the Get-WMIobject cmdlet
# Get-WMiobject -Class win32_service | select Name, PathName, ProcessId

# get-wmiobject -list | where { $_.Name -ilike "win32_[n-z]*" } | sort-object

# Get-WmiObject -Class Win32_Account | Get-Member

# Task: Grab the network adapter information using the WMI class
# Get the IP Address, default gateway, and the DNS servers.
# Bonus: get the DHCP server.
# Post your code to pineapple
# Running your code using a screen recorder.
# Get-WmiObject -Class Win32_NetworkAdapterConfiguration
Get-WMIobject -Class Win32_NetworkAdapterConfiguration | Where { $_.IPAddress } | Select-Object -ExpandProperty IPAddress
Get-WMIobject -Class Win32_NetworkAdapterConfiguration | Where { $_.DefaultIPGateway } | Select-Object -ExpandProperty DefaultIPGateway
Get-WMIobject -Class Win32_NetworkAdapterConfiguration | Where { $_.DNSDomain } | Select-Object -ExpandProperty DNSDomain