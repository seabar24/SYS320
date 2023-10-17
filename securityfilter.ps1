# Storyline: Review the Security Event Log

# Directory to save files:

$myDir = "C:\Users\sbarrick\Desktop\"

# List all the available windows Event logs
Get-Eventlog -list

# Create a prompt to allow user to select the log to view
$readLog = Read-Host -Prompt "Please select a log to review from the list above"

# print the results for the log
Get-EventLog -LogName $readLog -Newest 40 | where {$_.Message -ilike "*new process has been*" }| export-csv -NoTypeInformation `
-Path "$myDir\securitylogs.csv"

# Task: Create a prompt that allow the user to specify a keyword or phrase to search on.
# Find a string from your event logs to search on