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
    Write-Host "7. OS Build"
    Write-Host "8. Scheduled Tasks"
    Write-Host "9. Event Logs"
    $choice = Read-Host "`nSelect a choice above or 'q' to quit"

    # Retrieves all Running Processes and executable path
    if ($choice -eq "1") {
        
        $path = path
        $zipFolderPath = "C:\$path\zipFolder"
        $zipFilePath = Join-Path $zipFolderPath "incident_report.zip"
        if (-not (Test-Path $zipFolderPath)) {
            New-Item -ItemType Directory -Path $zipFolderPath | Out-Null
        }
        cls
        Write-Host "`nWait a few moments for the query to retrieve the services."
        sleep 3
        cls
        Get-Process | Select-Object StartTime, ProcessName, ID, Path | `
        Export-Csv -Path "C:\$path\processes.csv" -NoTypeInformation

        Write-Host "`nSaving to file..."
        sleep 3
        Write-Host "Done!"
        Read-Host "Press 'Enter' when you are done"
        hash -filePath "C:\$path\processes.csv"
        compress -sourceDir "C:\$path" -zipFilePath "$zipFilePath"
        incident_menu

    }
    #Will Query all registered services and the executable path
    elseif ($choice -eq "2") {

        $path = path
        $zipFolderPath = "C:\$path\zipFolder"
        $zipFilePath = Join-Path $zipFolderPath "incident_report.zip"
        if (-not (Test-Path $zipFolderPath)) {
            New-Item -ItemType Directory -Path $zipFolderPath | Out-Null
        }
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
        compress -sourceDir "C:\$path" -zipFilePath "$zipFilePath"
        incident_menu
    }
    # Retrieves all TCP Network Sockets
    elseif ($choice -eq "3") {
    
        $path = path
        $zipFolderPath = "C:\$path\zipFolder"
        $zipFilePath = Join-Path $zipFolderPath "incident_report.zip"
        if (-not (Test-Path $zipFolderPath)) {
            New-Item -ItemType Directory -Path $zipFolderPath | Out-Null
        }
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
        compress -sourceDir "C:\$path" -zipFilePath "$zipFilePath"
        incident_menu
    }
    # Retrieves User Information
    elseif ($choice -eq "4") {

        $path = path
        $zipFolderPath = "C:\$path\zipFolder"
        $zipFilePath = Join-Path $zipFolderPath "incident_report.zip"
        if (-not (Test-Path $zipFolderPath)) {
            New-Item -ItemType Directory -Path $zipFolderPath | Out-Null
        }
        cls
        Write-Host "Wait a few moments for the query to retrieve the users information."
        sleep 3
        Get-WmiObject -Class Win32_UserAccount | `
        Export-Csv -Path "C:\$path\userinfo.csv" -NoTypeInformation
       
        Write-Host "`nSaving to file..."
        sleep 3
        Write-Host "Done!"
        Read-Host "`nPress 'Enter' when you are done"
        hash -filePath "C:\$path\userinfo.csv"
        compress -sourceDir "C:\$path" -zipFilePath "$zipFilePath"
        incident_menu
    }
    # Retrieves Network information
    elseif ($choice -eq "5") {

        $path = path
        $zipFolderPath = "C:\$path\zipFolder"
        $zipFilePath = Join-Path $zipFolderPath "incident_report.zip"
        if (-not (Test-Path $zipFolderPath)) {
            New-Item -ItemType Directory -Path $zipFolderPath | Out-Null
        }

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
        compress -sourceDir "C:\$path" -zipFilePath "$zipFilePath"
        incident_menu
    }
    # Retrieves installed programs
    elseif ($choice -eq "6") {
        
        $path = path
        $zipFolderPath = "C:\$path\zipFolder"
        $zipFilePath = Join-Path $zipFolderPath "incident_report.zip"
        if (-not (Test-Path $zipFolderPath)) {
            New-Item -ItemType Directory -Path $zipFolderPath | Out-Null
        }

        cls
        Write-Host "Wait a few moments for the query to retrieve the installed programs."
        sleep 3
        cls

        Get-WmiObject -ClassName Win32_Product | Select-Object Name, Version, Vendor, InstallDate, InstallSource, PackageName, LocalPackage | `
        Export-Csv -Path "C:\$path\programs.csv" -NoTypeInformation

        Write-Host "`nSaving to file..."
        sleep 3
        Write-Host "Done!"
        Read-Host "`nPress 'Enter' when you are done"
        hash -filePath "C:\$path\programs.csv" -NoTypeInformation
        compress -sourceDir "C:\$path" -zipFilePath "$zipFilePath"
        incident_menu
    }
    # Retreieves the Operating System's Build
    elseif ($choice -eq "7") {

        $path = path
        $zipFolderPath = "C:\$path\zipFolder"
        $zipFilePath = Join-Path $zipFolderPath "incident_report.zip"
        if (-not (Test-Path $zipFolderPath)) {
            New-Item -ItemType Directory -Path $zipFolderPath | Out-Null
        }

        cls
        Write-Host "Wait a few moments for the query to retrieve the os build."
        sleep 3
        cls

        Get-CimInstance Win32_OperatingSystem | Select-Object Caption, Version, servicepackmajorversion, BuildNumber, CSName, LastBootUpTime | `
        Export-Csv -Path "C:\$path\osbuild.csv" -NoTypeInformation

        Write-Host "`nSaving to file..."
        sleep 3
        Write-Host "Done!"
        Read-Host "`nPress 'Enter' when you are done"
        hash -filePath "C:\$path\osbuild.csv" -NoTypeInformation
        compress -sourceDir "C:\$path" -zipFilePath "$zipFilePath"
        incident_menu
    }
    # Retrieves scheduled tasks that are out of the ordinary from normal Scheduled Tasks
    elseif ($choice -eq "8") {

        $path = path
        $zipFolderPath = "C:\$path\zipFolder"
        $zipFilePath = Join-Path $zipFolderPath "incident_report.zip"
        if (-not (Test-Path $zipFolderPath)) {
            New-Item -ItemType Directory -Path $zipFolderPath | Out-Null
        }

        cls
        Write-Host "Wait a few moments for the query to retrieve the Scheduled Tasks."
        sleep 3

        cls
        Get-ScheduledTask | Select-Object TaskName, TaskPath, Date, Author, Actions, Triggers, Description, State | Where Author -NotLike 'Microsoft*' | Where Author -ne $null | Where Author -NotLike '*@SystemRoot%\*' | `
        Export-Csv -Path "C:\$path\scheduledtasks.csv" -NoTypeInformation

        Write-Host "`nSaving to file..."
        sleep 3
        Write-Host "Done!"
        Read-Host "`nPress 'Enter' when you are done"
        hash -filePath "C:\$path\scheduledtasks.csv" -NoTypeInformation
        compress -sourceDir "C:\$path" -zipFilePath "$zipFilePath"
        incident_menu

    }
    # Retrieves the Event Logs from the last 20 entries of errors or warnings that appear as well as when they were generated, where, entrytype, and message.
    elseif ($choice -eq "9") {

        $path = path
        $zipFolderPath = "C:\$path\zipFolder"
        $zipFilePath = Join-Path $zipFolderPath "incident_report.zip"
        if (-not (Test-Path $zipFolderPath)) {
            New-Item -ItemType Directory -Path $zipFolderPath | Out-Null
        }

        cls
        Write-Host "Wait a few moments for the query to retrieve the Event Logs."
        sleep 3

        cls
        Get-Eventlog -LogName system -Newest 20 | Select-Object -Property TimeGenerated, Source, EntryType, Message | Where {$_.EntryType -eq "warning" -or $_.EntryType -eq "error"} | `
        Export-Csv -Path "C:\$path\eventlogs.csv" -NoTypeInformation

        Write-Host "`nSaving to file..."
        sleep 3
        Write-Host "Done!"
        Read-Host "`nPress 'Enter' when you are done"
        hash -filePath "C:\$path\eventlogs.csv" -NoTypeInformation
        compress -sourceDir "C:\$path" -zipFilePath "$zipFilePath"
        incident_menu
    }
    # Quit the program
    elseif ($choice -match "^[qQ]$") {

        break
    }
    # If choice is not equal to any of the above
    else {

        Write-Host -BackgroundColor red -ForegroundColor white "`nHOW MANY TIMES DO WE HAVE TO TEACH THIS LESSON OLD MAN?"
        sleep 5
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
    param (
        [string]$sourceDir,
        [string]$zipFilePath
    )

    Compress-Archive -Path $sourceDir -DestinationPath $zipFilePath -Force
    $zip = Get-FileHash -Path "$zipFilePath" -Algorithm SHA256
    $zip | Out-File "C:\$path\zip_checksum.txt" -Append

}
incident_menu