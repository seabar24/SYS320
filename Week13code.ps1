# Array of websites containing threat intell
function parseIntel() {
$drop_urls = @('https://rules.emergingthreats.net/blockrules/emerging-botcc.rules','https://rules.emergingthreats.net/blockrules/compromised-ips.txt')


#Asks for choice from User to pick which format of OS would they like to have threats parsed as.
cls
Write-Host "Which format of parsing would you like to choose?"
Write-Host " "
Write-Host "1. Windows"
Write-Host "2. Linux"
$choice = Read-Host "`nChoose 1 or 2" 

# Loop through the URLs for the rules list
foreach ($u in $drop_urls) {

    # Extract the filename
    $temp = $u.split("/")
    
   # The last element in the array plucked off is the filename
   $file_name = $temp[-1]
   
   if (Test-Path $file_name) {

        continue

   } else {

        # Download the rules list
        Invoke-WebRequest -Uri $u -OutFile $file_name

   } # Close if statement

} # Close the foreach loop

# Array containing the filename
$input_paths = @('.\compromised-ips.txt','.\emerging-botcc.rules')

# Extract the IP addresses.
# 108.190.109.107
#108.191.2.72
$regex_drop = '\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b'

# Append the IP addresses to the temporary IP list.
select-string -Path $input_paths -Pattern $regex_drop | `
ForEach-Object { $_.Matches } | `
ForEach-Object { $_.Value } | Sort-Object | Get-Unique | `
Out-File -FilePath "ips-bad.tmp"

# Switch Statement
switch ($choice) {
    "1" {
    # Adds Windows firewall rules and saves to file.
        (Get-Content -Path ".\ips-bad.tmp") | % `
            { $_ -replace "^",'netsh advfirewall firewall add rule name="BLOCK IP ADDRESS - ' -replace '$', '"' } | `
            Out-File -FilePath ".\msfirewall.netsh"
        }
    
    "2" {
    # After the IP, add the remaining IPTables syntax and save results to a file.
        (Get-Content -Path ".\ips-bad.tmp") | % `
            { $_ -replace "^","iptables -A INPUT -s " -replace "$", "-j DROP" } | `
            Out-File -FilePath ".\iptables.bash"
        }

    else {
    # Else if 1 or 2 are not chosen
        Write-Host -BackgroundColor red -ForegroundColor white "You're so wrong.`n Like super, duper, uber WRONG."
        sleep 3
        parseIntel
        }
    }
}
parseIntel