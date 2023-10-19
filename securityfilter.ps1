# Storyline: Review the Security Event Log

# Directory to save files:

$user = whoami | Split-Path -Leaf

$myDir = "C:\Users\$user\Desktop\"

# List all the available windows Event logs
Get-Eventlog -list

# Create a prompt to allow user to select the log to view
$readLog = Read-Host -Prompt "Please select a log to review from the list above"

# Creates a prompt to allow user to search for a keyword or phrase to search on.
$keyword= Read-Host -Prompt "Enter a keyword or phrase you would like to search for"

# print the results for the log
Get-EventLog -LogName $readLog | where {$_.Message -ilike "*$keyword*" } | export-csv -NoTypeInformation `
-Path "$myDir\securitylogs.csv"