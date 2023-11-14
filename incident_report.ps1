# Storyline: Incident Response Toolkit that retrieves the following:
# Running processes and the paths for each processes
# All registered services and paths to the exe. controlling the service
# TCP network sockets
# User account information
# NetworkAdapterConfiguration Info
# Powershell cmdlets to save 4 artifacts that would be useful in an incident response

# Main menu for Incident Report
function incident_menu (){
    cls
    Write-Host "Incident Response Toolkit"
    Write-Host "1. Running Processes"
    Write-Host "2. All Services"
    Write-Host "3. TCP Network Sockets"
    Write-Host "4. User Information"
    Write-Host "5. Network Configuration Information"
    Write-Host "6. Installed Programs"
    $choice = Read-Host "`nSelect a choice above or 'q' to quit"

    # Retrieves all Running Processes and executable path
    if ($choice -eq "1") {
        
        $path = path
        cls
        Write-Host "`nWait a few moments for the query to retrieve the services."
        sleep 3
        cls
        Get-Process | Select-Object ProcessName, Path, ID | `
        Export-Csv -Path "C:\$path\processes.csv" -NoTypeInformation

        Write-Host "`nSaving to file..."
        sleep 3
        Write-Host "Done!"
        Read-Host "Press 'Enter' when you are done"
        hash -filePath "C:\$path\processes.csv"
        compress -sourceDir "C:\$path"
        incident_menu

    }
    #Will Query all registered services and the executable path
    elseif ($choice -eq "2") {

        cls
        $path = path
        cls
        $wmiQuery = "SELECT * FROM Win32_Service"
        $services = Get-WmiObject -Query $wmiQuery

        Write-Host "`nWait a few moments for the query to retrieve the services."
        sleep 3
        cls

        $Output = foreach ($service in $services) {
           
            $Name = $service.Name
            $exePath = $service.PathName
            Write-Host "Service Name: $Name"
            Write-Host "Executable Path: $exePath"
            Write-Host ""
        }
        $Output | Export-Csv -Path "C:\$path\services.csv" -NoTypeInformation

        Write-Host "`nSaving to file..."
        sleep 3
        Write-Host "Done!"
        Read-Host "Press 'Enter' when you are done"
        hash -filePath "C:\$path\services.csv"
        compress -sourceDir "C:\$path"
        incident_menu
    }
    # Retrieves all TCP Network Sockets
    elseif ($choice -eq "3") {
    
        $path = path
        cls
        Write-Host "Wait a few moments for the query to retrieve the TCP Information."
        sleep 3
        
        cls
        Get-NetTCPConnection | Export-Csv -Path "C:\$path\tcpsockets.csv" -NoTypeInformation
       
        Write-Host "`nSaving to file..."
        sleep 3
        Write-Host "Done!"
        Read-Host "`nPress 'Enter' when you are done"
        hash -filePath "C:\$path\tcpsockets.csv"
        compress -sourceDir "C:\$path"
        incident_menu
    }
    # Retrieves User Information
    elseif ($choice -eq "4") {

        $path = path
        cls
        Write-Host "Wait a few moments for the query to retrieve the TCP Information."
        sleep 3
        Get-WmiObject -Class Win32_UserAccount | `
        Export-Csv -Path "C:\$path\userinfo.csv" -NoTypeInformation
       
        Write-Host "`nSaving to file..."
        sleep 3
        Write-Host "Done!"
        Read-Host "`nPress 'Enter' when you are done"
        hash -filePath "C:\$path\userinfo.csv"
        compress -sourceDir "C:\$path"
        incident_menu
    }
    # Retrieves Network information
    elseif ($choice -eq "5") {

        $path = path

        cls
        Write-Host "Wait a few moments for the query to retrieve the Network Configuration."
        sleep 3
        cls
        Get-WmiObject -Class Win32_NetworkAdapterConfiguration | `
        Select-Object @{n='IPAddress';e={$_.IPAddress -join ','}}, `
        @{n='\DefaultIPGateway';e={$_.DefaultIPGateway -join ','}}, `
        {n='DNSServerSearchOrder';e={$_.DNSServerSearchOrder -join ','}} | `
        Export-Csv -Path "C:\$path\networkinfo.csv" -NoTypeInformation

        Write-Host "`nSaving to file..."
        sleep 3
        Write-Host "Done!"
        Read-Host "`nPress 'Enter' when you are done"
        hash -filePath "C:\path\networkinfo.csv" 
        compress -sourceDir "C:\$path"
        incident_menu
    }
    # Retrieves installed programs
    elseif ($choice -eq "6") {
        
        $path = path

        cls
        Write-Host "Wait a few moments for the query to retrieve the Network Configuration."
        sleep 3
        cls

        Get-WmiObject -ClassName Win32_Product | Select-Object Name, Version, Vendor, InstallDate, InstallSource, PackageName, LocalPackage | `
        Export-Csv -Path "C:\$path\programs.csv" -NoTypeInformation

        Write-Host "`nSaving to file..."
        sleep 3
        Write-Host "Done!"
        Read-Host "`nPress 'Enter' when you are done"
        hash -filePath "C:\$path\programs.csv" -NoTypeInformation
        compress -sourceDir "C:\$path"
        incident_menu
    }
    # Quit the program
    elseif ($choice -match "^[qQ]$") {

        break
    }
    # If choice is not equal to any of the above
    else {

        Write-Host -BackgroundColor red -ForegroundColor white "`nHOW MANY TIMES DO WE HAVE TO TEACH THIS LESSON OLD MAN?"
        sleep 10
        incident_menu
    }
}
# Tests file path for output of commands. If true, will return variable, else will do a recursive loop till a valid path is found.
function path() {
    cls
    $path = Read-Host "Enter the path in which you want to save each option"
    if (Test-Path -Path "C:\$path") {
        return $path
    }else {
        Write-Host -BackgroundColor red -ForegroundColor white "`nPath is not valid. Try again."
        sleep 5
        path
    }
}
# Creates a hash for each file and appends to checksum file for each new file made.
function hash() {
    param (
        [string]$filePath
    )

    $hash = Get-FileHash -Path $filePath -Algorithm SHA256
    $hash | Out-File "C:\$path\checksums.txt" -Append
}
# Compresses the outputs of the commands into a .zip file.
function compress() {
    param([string]$sourceDir)

    $path = Read-Host "Enter the file path for the .zip file"
    $zipDir = Join-Path (cd .. | Resolve-Path) $path

    Compress-Arhcive -Path $sourceDir -DestinationPath "$path/incident_report.zip"
    Get-FileHash -Path "$path/incident_report.zip" -Algorithm SHA256 | `
    Out-File "C:\$path\zip_checksum.txt" -Append

}
incident_menu